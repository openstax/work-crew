module WorkCrew
  class TestWorker
    def initialize(group_uuid:)
      @group_uuid     = group_uuid
      @counter        = 0
    end

    def do_work(work_crew_member:)
      @counter += 1
      log(work_crew_member) { "#{work_crew_member.am_boss? ? '*' : ' '} #{@counter % 10} working away as usual..." }
    end

    def do_boss(work_crew_member:)
      log(work_crew_member) { "  doing boss stuff..." }
    end

    def do_end(work_crew_member:)
      log(work_crew_member) { "  end block..." }
      return false
    end

    def do_dead_record(work_crew_member:, record:)
      log(work_crew_member) { " cleaning up record #{record.instance_uuid}" }
    end

    def log(work_crew_member)
      puts "#{Time.now.utc.iso8601(6)} #{Process.pid} #{work_crew_member.group_uuid}:[#{work_crew_member.modulo}/#{work_crew_member.count}] #{work_crew_member.instance_desc} #{yield}"
    end
  end

end

namespace :work_crew do
  namespace :member do

    desc "WorkCrew::Member test"
    task :test, [:group_uuid, :work_interval, :boss_interval, :end_interval, :timing_modulo, :timing_offset] => :environment do |t, args|
      group_uuid    = args[:group_uuid]
      work_interval = args[:work_interval].nil? ? nil : args[:work_interval].to_f.seconds
      boss_interval = args[:boss_interval].nil? ? nil : args[:boss_interval].to_f.seconds
      end_interval  = args[:end_interval].nil?  ? nil : args[:end_interval].to_f.seconds
      timing_modulo = (args[:timing_modulo] || '5.0').to_f.seconds
      timing_offset = (args[:timing_offset] || '0.0').to_f.seconds

      worker = WorkCrew::TestWorker.new(
        group_uuid: group_uuid,
      )

      member = WorkCrew::Member.new(
        min_work_interval:    work_interval,
        work_block:           lambda { |work_crew_member:|
                                worker.do_work(work_crew_member: work_crew_member)
                              },
        min_boss_interval:    boss_interval,
        boss_block:           lambda { |work_crew_member:|
                                worker.do_boss(work_crew_member: work_crew_member)
                              },
        min_end_interval:     end_interval,
        end_block:            lambda { |work_crew_member:|
                                worker.do_end(work_crew_member: work_crew_member)
                              },
        group_uuid:           group_uuid,
        group_desc:           'some group desc',
        instance_uuid:        SecureRandom.uuid.to_s,
        instance_desc:        ENV['ID'] || "%05d" % Kernel.rand(1000),
        dead_record_timeout:  1.seconds,
        dead_record_block:    lambda { |work_crew_member:, record:|
                                worker.do_dead_record(work_crew_member: work_crew_member, record: record)
                              },
        reference_time:       Chronic.parse('Jan 1, 2000 12:00:00pm'),
        timing_modulo:        timing_modulo,
        timing_offset:        timing_offset,
      )

      puts "#{Time.now.utc.iso8601(6)} #{Process.pid} starting work crew member..."
      member.run
    end
  end
end
