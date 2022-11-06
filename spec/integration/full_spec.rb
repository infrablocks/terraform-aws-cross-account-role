# frozen_string_literal: true

require 'spec_helper'

describe 'full' do
  let(:role_name) do
    var(role: :full, name: 'role_name')
  end
  let(:policy_arn) do
    var(role: :full, name: 'policy_arn')
  end
  let(:assumable_by_account_ids) do
    var(role: :full, name: 'assumable_by_account_ids')
  end

  let(:role_arn) do
    output(role: :full, name: 'role_arn')
  end

  before(:context) do
    apply(role: :full)
  end

  after(:context) do
    destroy(
      role: :full,
      only_if: -> { !ENV['FORCE_DESTROY'].nil? || ENV['SEED'].nil? }
    )
  end

  describe 'cross account role' do
    subject(:cross_account_role) { iam_role(role_name) }

    it { is_expected.to exist }
    its(:arn) { is_expected.to(eq(role_arn)) }
    it { is_expected.to have_iam_policy(policy_arn) }

    it 'is assumable by the provided accounts' do
      actual = JSON.parse(
        CGI.unescape(cross_account_role.assume_role_policy_document),
        symbolize_names: true
      )
      expected = {
        Version: '2012-10-17',
        Statement: [
          {
            Sid: '',
            Effect: 'Allow',
            Action: 'sts:AssumeRole',
            Principal: {
              AWS: "arn:aws:iam::#{assumable_by_account_ids[0]}:root"
            }
          }
        ]
      }

      expect(actual).to(eq(expected))
    end
  end
end
