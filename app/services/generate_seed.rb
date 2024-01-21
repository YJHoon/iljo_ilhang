class GenerateSeed
  def self.exec(cls)
    cls.generate_seed
  end

  private

  Election.instance_eval do
    def generate_seed
      OpenApi::ElectionDataService.new.update
      print "Election Done"
    end
  end

  Member.instance_eval do
    def generate_seed
      OpenApi::MemberDataService.new.update
      print "Member Done"
      crawling_member = Crawling::UpdateMemberDataService.new
      crawling_member.update_member_image_and_seq_id
      crawling_member.update_member_show_info
      print "Member Info Done"
    end
  end

  Bill.instance_eval do
    def generate_seed
      OpenApi::BillDataService.new.update
      print "Bill Done"
    end
  end

  Candidate.instance_eval do
    def generate_seed
      OpenApi::CandidateDataService.new.update
      print "Candidate Done"
    end
  end
end
