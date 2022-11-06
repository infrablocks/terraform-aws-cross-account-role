# frozen_string_literal: true

require 'spec_helper'

describe 'cross account role' do
  let(:role_name) do
    var(role: :root, name: 'role_name')
  end
  let(:policy_arn) do
    var(role: :root, name: 'policy_arn')
  end
  let(:assumable_by_account_ids) do
    var(role: :root, name: 'assumable_by_account_ids')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a role' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role')
              .once)
    end

    it 'uses the provided role name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role')
              .with_attribute_value(:name, role_name))
    end

    it 'uses an assume role policy allowing the provided accounts to assume' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role')
              .with_attribute_value(
                :assume_role_policy,
                a_policy_with_statement(
                  Effect: 'Allow',
                  Action: 'sts:AssumeRole',
                  Principal: {
                    AWS: assumable_by_account_ids[0]
                  }
                )
              ))
    end

    it 'creates a role policy attachment' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role_policy_attachment')
              .once)
    end

    it 'uses the provided policy ARN' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role_policy_attachment')
              .with_attribute_value(:policy_arn, policy_arn))
    end
  end
end
