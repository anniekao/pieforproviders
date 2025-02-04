# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttendancePolicy do
  subject { described_class }

  let(:user) { create(:confirmed_user) }
  let(:non_owner) { create(:confirmed_user) }
  let(:business) { create(:business, user: user) }
  let(:admin) { create(:admin) }
  let(:child) { create(:child, business: business) }
  let(:child_approval) { child.child_approvals.first }
  let(:attendance) { create(:attendance, child_approval: child_approval) }

  describe AttendancePolicy::Scope do
    context 'when authenticated as an admin' do
      it 'returns all attendances' do
        attendances = described_class.new(admin, Attendance).resolve
        expect(attendances).to match_array([attendance])
      end
    end

    context 'when logged in as an owner user' do
      it 'returns the attendances associated to the user' do
        attendances = described_class.new(user, Attendance).resolve
        expect(attendances).to match_array([attendance])
      end
    end

    context 'when logged in as a non-owner user' do
      it 'returns an empty relation' do
        attendances = described_class.new(non_owner, Attendance).resolve
        expect(attendances).to be_empty
      end
    end
  end
end
