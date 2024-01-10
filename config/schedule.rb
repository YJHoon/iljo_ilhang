every 1.day, at: "2:00 am" do
  runner "UpdateMembersJob.perform_later"
  runner "UpdateBillsJob.perform_later"
end
