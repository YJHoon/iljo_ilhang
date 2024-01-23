class GenerateSeed
  def self.exec(cls)
    cls.generate_seed
  end

  private

  Election.instance_eval do
    def generate_seed
      OpenApi::ElectionDataService.new.update
      puts "Election Done"
    end
  end

  Member.instance_eval do
    def generate_seed
      OpenApi::MemberDataService.new.update
      puts "Member Done"
      crawling_member = Crawling::UpdateMemberDataService.new
      crawling_member.update_member_image_and_seq_id
      puts "Member Info image seqId Done"
      crawling_member.update_member_show_info
      puts "Member Info Done"
    end
  end

  Bill.instance_eval do
    def generate_seed
      OpenApi::BillDataService.new.update
      puts "Bill Done"
    end
  end

  Candidate.instance_eval do
    def generate_seed
      OpenApi::CandidateDataService.new.update
      puts "Candidate Done"
    end
  end
end
