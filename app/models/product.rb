class Product < ActiveRecord::Base
  has_many :users
  searchkick special_characters: true,
    mappings: {
      product: {
        properties: {
          name: {
            type: "string",
            analyzer: "kuromoji_analyzer"
          }
        }
      }
    },
    settings: {
      analysis: {
        filter: {
          hashtag_filter: {
            type: "word_delimiter",
            type_table: ["# => ALPHA"]
          }
        },
        analyzer: {
          kuromoji_analyzer: {
            type: "custom",
            tokenizer: "kuromoji_tokenizer",
            filter: ["kuromoji_stemmer"]
          },
          hashtag_analyzer: {
            type: "custom",
            tokenizer: "whitespace",
            filter: ["lowercase", "hashtag_filter"]
          }
        }
      }
    }

end
