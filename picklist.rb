class Picklist
  def initialize(object, fields)
    @object = object
    @fields = fields
  end

  def update
    PicklistService.new(@object, @fields).update_picklist
  end
end
