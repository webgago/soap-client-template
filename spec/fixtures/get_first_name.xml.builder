xml.type :getFirstName, {"id"=>"string", "xmlns:type"=>"http://example.com/UserService/type/"} do
  xml.comment! 'Optional:'
  xml.userIdentifier 'string'
  xml.comment! 'Optional:'
  xml.filter do
    xml.type :age, '100'
    xml.type :gender, 'female'
  end
end