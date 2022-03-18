require 'spec_helper'
require 'json'
require 'uri'

describe 'cross account role' do
  let(:role_name) { vars.role_name }
  let(:role_arn) { output_for(:harness, 'role_arn') }
  let(:policy_arn) { vars.policy_arn }
  let(:assumable_by_account_ids) { vars.assumable_by_account_ids }

  subject { iam_role(role_name) }

  it { should exist }
  its(:arn) { should(eq(role_arn)) }
  it { should have_iam_policy(policy_arn) }

  it 'should be assumable by the provided accounts' do
    actual = JSON.parse(
      CGI.unescape(subject.assume_role_policy_document),
      symbolize_names: true)
    expected = {
      Version: "2012-10-17",
      Statement: [
        {
          Sid: "",
          Effect: "Allow",
          Action: "sts:AssumeRole",
          Principal: {
            AWS: "arn:aws:iam::#{assumable_by_account_ids[0]}:root"
          }
        }
      ]
    }

    expect(actual).to(eq(expected))
  end
end
