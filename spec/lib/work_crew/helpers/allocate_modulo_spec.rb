require 'rails_helper'

RSpec.describe 'WorkCrew::Helpers.allocate_modulo' do
  context 'when all modulos are already properly assigned' do
    context 'does nothing and returns falsy' do
      let(:target_group_uuid)    { SecureRandom.uuid.to_s }
      let(:target_instance_uuid) { '33521a44-c825-4e9f-bf55-a1bcde2db82c'}

      let!(:live_records) {[
        create(:work_crew_member_data,
          group_uuid: target_group_uuid, instance_modulo: 2, instance_count: 4,
        ),
        create(:work_crew_member_data,
          group_uuid: target_group_uuid, instance_modulo: 0,
        ),
        create(:work_crew_member_data,
          group_uuid: target_group_uuid, instance_modulo: 1,
        ),
        create(:work_crew_member_data,
          group_uuid: target_group_uuid, instance_modulo: 3,
        ),
      ]}

      let(:target_instance_record) { live_records.at(2) }
      let(:boss_record)            { live_records.at(0) }

      let!(:updated_after_time) { sleep 0.01; Time.now.utc }

      let!(:return_value) {
        WorkCrew::Helpers.allocate_modulo(
          instance_record: target_instance_record,
          live_records:    live_records,
          boss_record:     boss_record,
        )
      }

      let!(:updated_records) { WorkCrew::MemberData.where('updated_at > ?', updated_after_time) }

      it 'should pass' do
        expect(updated_records.count).to eq(0)
        expect(return_value).to be_falsy
      end
    end
  end

  context 'when target instance modulo is properly assigned but other modulos are not' do
    context 'does nothing and returns falsy' do
      let(:target_group_uuid)    { SecureRandom.uuid.to_s }
      let(:target_instance_uuid) { '33521a44-c825-4e9f-bf55-a1bcde2db82c'}

      let!(:live_records) {[
        create(:work_crew_member_data,
          group_uuid: target_group_uuid, instance_modulo: 5, instance_count: 4,
        ),
        create(:work_crew_member_data,
          group_uuid: target_group_uuid, instance_modulo: 0,
        ),
        create(:work_crew_member_data,
          group_uuid: target_group_uuid, instance_modulo: 1,
        ),
        create(:work_crew_member_data,
          group_uuid: target_group_uuid, instance_modulo: -3,
        ),
      ]}

      let(:target_instance_record) { live_records.at(2) }
      let(:boss_record)            { live_records.at(0) }

      let!(:updated_after_time) { sleep 0.01; Time.now.utc }

      let!(:return_value) {
        WorkCrew::Helpers.allocate_modulo(
          instance_record: target_instance_record,
          live_records:    live_records,
          boss_record:     boss_record,
        )
      }

      let!(:updated_records) { WorkCrew::MemberData.where('updated_at > ?', updated_after_time) }

      it 'should pass' do
        expect(updated_records.count).to eq(0)
        expect(return_value).to be_falsy
      end
    end
  end

  context 'when target instance modulo is not properly assigned' do
    context 'sets the target instance modulo to a valid value and returns truthy' do
      let(:target_group_uuid)    { SecureRandom.uuid.to_s }
      let(:target_instance_uuid) { '33521a44-c825-4e9f-bf55-a1bcde2db82c'}

      let!(:live_records) {[
        create(:work_crew_member_data,
          group_uuid: target_group_uuid, instance_modulo: 2, instance_count: 4,
        ),
        create(:work_crew_member_data,
          group_uuid: target_group_uuid, instance_modulo: 5,
        ),
        create(:work_crew_member_data,
          group_uuid: target_group_uuid, instance_modulo: 6,
        ),
        create(:work_crew_member_data,
          group_uuid: target_group_uuid, instance_modulo: 3,
        ),
      ]}

      let(:target_instance_record) { live_records.at(2) }
      let(:boss_record)            { live_records.at(0) }

      let!(:updated_after_time) { sleep 0.01; Time.now.utc }

      let!(:return_value) {
        WorkCrew::Helpers.allocate_modulo(
          instance_record: target_instance_record,
          live_records:    live_records,
          boss_record:     boss_record,
        )
      }

      let!(:updated_records) { WorkCrew::MemberData.where('updated_at > ?', updated_after_time) }

      it 'should pass' do
        expect(updated_records.count).to eq(1)
        expect(updated_records.first.id).to eq(target_instance_record.id)
        expect([0,3]).to include(updated_records.first.instance_modulo)
      end
    end
  end
end
