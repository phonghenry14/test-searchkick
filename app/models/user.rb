class User < ActiveRecord::Base
  belongs_to :product
  belongs_to :position
  belongs_to :project
  belongs_to :school
  belongs_to :skill
  belongs_to :city

  searchkick suggest: [:name], fields: ["name", "product_name", "age", "project_name",
    "position_name", "skill_name", "school_name", "city_name"],
  merge_mappings: true,
  mappings: {
    user: {
      properties: {
        name: {
          type: "string",
          analyzer: "kuromoji_analyzer"
        },
        age: {
          type: "integer",
          index: "not_analyzed"
        },
        created_at: {
          type: "date",
          format: "dd-MM-yyy"
        },
        ja_product_name: {
          type: "string",
          analyzer: "kuromoji_analyzer"
        },
        en_product_name: {
          type: "string",
          analyzer: "default"
        },
        city_name: {
          type: "string",
          analyzer: "kuromoji_analyzer"
        },
        project_name: {
          type: "string",
          analyzer: "kuromoji_analyzer"
        },
        position_name: {
          type: "string",
          analyzer: "kuromoji_analyzer"
        },
        skill_name: {
          type: "string",
          analyzer: "kuromoji_analyzer"
        },
        school_name: {
          type: "string",
          analyzer: "kuromoji_analyzer"
        },
        is_admin: {
          type: "boolean",
          analyzer: "default"
        },
        comments:{
          type: "nested",
          properties: {
            id: {type: "string", index: "not_analyzed"},
            content: {type: "string", analyzer: "kuromoji_analyzer"}
          }
        }
      }
    }
  },
  settings: {
    index: {
      analysis: {
        analyzer: {
          kuromoji_analyzer: {
            type: "custom",
            tokenizer: "kuromoji_tokenizer"
          }
        }
      }
    }
  }

  def en_product_name
    self.product.name
  end

  def ja_product_name
    self.product.name
  end

  def project_name
    self.project.name
  end

  def position_name
    self.position.name
  end

  def city_name
    self.city.name
  end

  def skill_name
    self.skill.name
  end

  def school_name
    self.school.name
  end

  def is_admin
    self.id.odd? ? true : false
  end

  def comments
    [{
      id: self.id.to_s,
      content: "content comment of #{self.name}"
    }]
  end

  def search_data
    attributes.merge(
      name: name,
      age: age,
      en_product_name: en_product_name,
      ja_product_name: ja_product_name,
      project_name: project_name,
      position_name: position_name,
      city_name: city_name,
      skill_name: skill_name,
      school_name: school_name,
      created_at: created_at.strftime("%d-%m-%Y"),
      is_admin: is_admin,
      comments: comments
    )
  end
end
