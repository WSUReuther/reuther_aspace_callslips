class CallSlipGenerator
  attr_accessor :box

  def initialize(aspace_uri)
    jsonmodel_properties = JSONModel.parse_reference(aspace_uri)
    @jsonmodel_type = jsonmodel_properties[:type]
    @id = jsonmodel_properties[:id]
    @repository = jsonmodel_properties[:repository]
    @repo_id = JSONModel.parse_reference(@repository)[:id]

    resource_info = get_resource_info
    @call_slip_db = AppConfig[:call_slip_db]
    @title = resource_info[:title]
    @accession = resource_info[:accession]
    @physloc = resource_info[:physloc]
  end

  def generate_url
    params = call_slip_params
    url = "#{@call_slip_db}?#{params.to_query}"
    url
  end

  def get_resource_info
    if @jsonmodel_type === "resource"
      res = JSONModel(:resource).find(@id, :repo_id => @repo_id)
    elsif @jsonmodel_type === "archival_object"
      ao = JSONModel(:archival_object).find(@id, :repo_id => @repo_id)
      if ao["instances"].length > 0
        container_instance = ao["instances"].find{|inst| inst["sub_container"] and inst["sub_container"].length > 0}
        top_container_ref = container_instance ? container_instance["sub_container"]["top_container"]["ref"] : false
        if top_container_ref
          top_container = JSONModel(:top_container).find_by_uri(top_container_ref)
          @box = top_container["indicator"]
        end
      end
      res = JSONModel(:resource).find_by_uri(ao["resource"]["ref"])
    end
    physloc_note = res["notes"].find{|note| note["type"] == "physloc"}
    physloc_content = physloc_note ? physloc_note["content"][0] : ""
    {:title => res["title"], :accession => res["ead_id"], :physloc => physloc_content}
  end

  def call_slip_params
    {:Title => @title, :Accession => @accession, :Physloc => @physloc, :Boxes => @box}
  end

end
