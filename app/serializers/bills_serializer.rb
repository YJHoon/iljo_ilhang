class BillsSerializer < Panko::Serializer
  attributes :id, :bill_no, :bill_name, :proc_result
end
