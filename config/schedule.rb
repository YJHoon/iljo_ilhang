every 1.day, at: "2:00 am" do
  runner "UpdateMemberJob.perform_later"
end
