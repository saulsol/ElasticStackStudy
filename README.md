### 엘라스틱서치란?

- 오픈 소스, 분산, RESTful 검색 및 분석 엔진, 확장 가능한 데이터 저장소 및 벡터 데이터 베이스

⇒ 검색 및 데이터 분석에 최적화된 데이터베이스 

### 엘라스틱서치 주요 활용 사례

1. 데이터 수집 및 분석 
    1. 대규모 데이터(로그 등)를 수집 및 분석하는 데 최적화되어 있다.
    2. ELK = ElasticSearch(데이터 저장) + Logstash(데이터 수집 및 가공) + Kibaba(데이터 시각화)를 같이 활용해 데이터를 수집 및 분석한다. 

1. 검색 최적화 

### 엘라스틱서치의 분석이란?

"Elastic certification Guide” 이러한 문장이 있다고 가정해 보자.

이 텍스트가 analysis과정을 거치면 아래와 같이 변한다.

```jsx
elastic
certification
guide
```

```jsx
Elastic certification Guide
        ↓
소문자 변환
        ↓
elastic certification guide
        ↓
단어 분리 (tokenize)
        ↓
[elastic, certification, guide]
```

- 텍스트들을 변환하고 분리하는 과정을 거친다.

***. keyword ⇒ 분석을 하지 않고 텍스트 그대로 유지하라는 키워드*** 

### 1.1 Elasticsearch 작동 방식 (INTRO)

- REST API 방식으로 통신

**<클러스터에 대한 기본 정보>** 

```jsx
GET / 
```

response

```jsx
{
  "name" : "node1",
  "cluster_name" : "cluster1",
  "cluster_uuid" : "ZIZfXHjWQRyzJcBJTtiGww",
  "version" : {
    "number" : "8.1.3",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "39afaa3c0fe7db4869a161985e240bd7182d7a07",
    "build_date" : "2022-04-19T08:13:25.444693396Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

**<데이터 조회>**

```jsx
GET kibana_sample_data_ecommerce/_search
```

**<데이터 삽입 : RESTapi>**

```jsx
curl -X POST "localhost:9200/users/_doc" -H 'Content-Type: application/json' -d '
	{
		"name" : "saul",
		"email":"test@naver.com"
	}'
```

- 로그인 및 https 설정이 붙어있는 경우 URL에 추가적인 인자 값들이 들어간다.

**<데이터 조회 : RESTapi>**

```jsx
curl -X GET "localhost:9200/users/_search" -H 'Content-Type: application/json' -d '
	{
		"query"{
			"match_all": {}
		}
	}'
```

- 일치하는 데이터 중 10개의 문서를 리턴(default)

### 1.2 Data In

1. Using the Elasticsearch API, index a document that meets these requirements:
    - is indexed into an index called `my_index`
    - has an ID of 1
    - contains one field called `my_field`
    - has one value for the `my_field` field: `Hello world!`

```jsx
PUT my_index/_doc/1
{
  "my_field":"hello world"
}
```

- URL  타입 : PUT {index}/_doc/{id}
    - type은 7.X 이후부터 _doc 하나만 사용한다.

1. Use the Elasticsearch Get by ID API to retrieve the document you have just indexed. (방금 추가한 문서를 ID 로 조회하세요)
    
    ```jsx
    GET my_index/_doc/1
    ```
    
- 조회도 마찬가지로 {idx}/타입/{id} 형식으로 조회한다.

 

### 1.3 Information Out

1. As an Elasticsearch engineer, the query language you will use most often is the query DSL. Let's use the query DSL to mimic the last query that you executed in Discover. Write a `match` query on the `blogs` index that searches for blogs with the word `certification` in the blog's `title` field. You should get 2 hits.

```jsx
GET blogs/_search
{
  "query": {
    "match": {
      "title": "certification"
    }
  }
}
```

- request.query.match.title = “certification”

1. Change the query so that it searches for blogs with the words `Elastic certification` in the `title` field. How many hits did you get?

```jsx
GET blogs/_search
{
  "query": {
    "match": {
      "title": "Elastic certification"
    }
  }
}
```

- request.query.match.title = “Elastic certification”

```jsx
title : elastic OR title : certification
```

- match 쿼리는 Analyzer 가 토큰으로 만들어 분석한다.

**AND 조건으로 바꾸는 경우** 

```jsx
GET blogs/_search
{
  "query": {
    "match": {
      "title": {
        "query": "Elastic certificcation",
        "operator": "and"
      }     
    }
  }
}
```

- request.query.match.title.query : "Elastic certificcation"
- request.query.match.title.operator : "and"

1. Notice you get 1689 hits when you search for `Elastic certification` in the `title`. Why do you think there are 1687 additional hits?

⇒  or

1. Execute the following request to retrieve the top 10 authors:

```jsx
GET blogs/_search
{
  "size": 0,
  "aggregations": {
    "top_authors": {
      "terms": {
        "field": "authors.full_name.keyword"
      }
    }
  }
}
```

- request.size: 0
    - size 가 0개인 경우는 document가 필요 없다는 뜻이다.
    - 
- request.aggregations.top_authors.terms.field = "authors.full_name.keyword”
    - aggregations ⇒ 통계를 사용하겠다는 의미
    - top_authors ⇒ 임의로 붙인 변수 명

```jsx
"terms": {
  "field": "authors.full_name.keyword"
}
```

- authors.full_name ⇒ groupBy
- keyword ⇒ String 값 원본 그대로 사용하겠다(풀 네임으로 사용해야 통계가 올바르게 작동할 수 있다.)

### 2.1 Strings in Elasticsearch

1. Write a match query on the blogs index that searches for blogs with the name `Steve` as the `authors.first_name`. You should get 135 hits.

```jsx
GET blogs/_search
{
  "query": {
    "match": {
      "authors.first_name": "steve"
    }
  }
}
```

- request.query.match.authors.first_name = "steve"

1. Update the previous query to search for `steve` instead of `Steve`. How many hits are you expecting?

```jsx
GET blogs/_search
{
  "query": {
    "match": {
      "authors.first_name": "Steve"
    }
  }
}
```

- 대소문자는 관련이 없다.

1. pdate the query, to use the `authors.first_name.keyword` instead of the `authors.first_name` field. Why do you have zero result?

```jsx
GET blogs/_search
{
  "query": {
    "match": {
      "authors.first_name.keyword": "steve"
    }
  }
}
```

- .keyword 가 붙은 경우는 엘라스틱서치가 분석을 진행하지 않는다.
- 따라서 저장된 first_name은 “Steve” 인데 넘겨준 데이터는 분석을 하지 않기 때문에 일치하는 값이 없다.
    - 따라서 result 값은 0이 나온다.

1. Using they `keyword` field, update the query to get the same blogs as the first query.

```jsx
GET blogs/_search
{
  "query": {
    "match": {
      "authors.first_name.keyword": "Steve"
    }
  }
}
```

### 2.2 Overview of mappings

1. Index the following sample document, which also creates a new index called `sample_blog`:

```jsx
POST sample_blog/_doc
{
  "@timestamp": "2021-03-10T16:00:00.000Z",
  "abstract": "The Joy of Painting",
  "author": "Bob Ross",
  "body": "Painting should do one thing. It should put happiness in your heart. We'll take a little bit of Van Dyke Brown. Isn't that fantastic? You can just push a little tree out of your brush like that. Mix your color marbly don't mix it dead.",
  "body_word_count": 55,
  "category": "Painting",
  "title": "Making Happy Little Trees",
  "utl": "/blog/happy-little-trees",
  "published": true
}

```

1. View the default mappings that were created. Elasticsearch did its best to guess the data types - but notice a lot of the fields are of type `text` and `keyword`:

```jsx
GET sample_blog/_mapping
```

- sample_blog의 인덱스의 필드 구조와 타입을 보여달라는 명령어

```jsx
{
  "sample_blog" : {
    "mappings" : {
      "properties" : {
        "@timestamp" : {
          "type" : "date"
        },
        "abstract" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "author" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "body" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "body_word_count" : {
          "type" : "long"
        },
        "category" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "published" : {
          "type" : "boolean"
        },
        "title" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "utl" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        }
      }
    }
  }
}

```

1. Create a new index called `test_blogs` based on the `sample_blog` mapping. Configure `test_blogs` to satisfy the following requirements:
- `@timestamp` is a `date`
- `body_word_count` is an integer
- the `abstract`, `body`, and `title` fields are of type `text` only
- the `author`, `category` and `url` fields are of type `keyword` only
- `published` is of type `boolean`

```jsx
PUT test_blogs
{
  "mappings": {
    "properties": {
      "@timestamp" : {
        "type" : "date"
      },
      "abstract" : {
        "type" : "text"
      },
      "author": {
        "type": "keyword"
      },
      "body": {
        "type": "text"
      },
      "body_word_count" : {
        "type": "integer"
      },
      "category" : {
        "type": "keyword"
      },
      "published" : {
        "type": "boolean"
      },
      "title" : {
        "type": "text"
      }, 
      "utl" : {
        "type" : "boolean"
      }
    }
  }
}
```

1. Index the document from step 1 into your new `test_blogs` index. The document should be indexed without any issues with the mapping or data types.

```jsx
POST test_blogs/_doc
{
  "@timestamp": "2021-03-10T16:00:00.000Z",
  "abstract": "The Joy of Painting",
  "author": "Bob Ross",
  "body": "Painting should do one thing. It should put happiness in your heart. We'll take a little bit of Van Dyke Brown. Isn't that fantastic? You can just push a little tree out of your brush like that. Mix your color marbly don't mix it dead.",
  "body_word_count": 55,
  "category": "Painting",
  "title": "Making Happy Little Trees",
  "utl": "/blog/happy-little-trees",
  "published": "true"
}

```

1. Now let's make some changes to the `blogs` index. First, create a new `blogs_fixed` index.

```jsx
PUT blogs_fixed
```

1. Reindex all of the documents from the `blogs` index into your new `blogs_fixed` index.

```jsx
PUT blogs_fixed/_mapping
{
  "_meta": {
    "created_by": "Elastic Student"
  },
  "properties": {
    "authors": {
      "properties": {
        "company": {
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
        },
        "first_name": {
          "type": "keyword"
        },
        "full_name": {
          "type": "text"
        },
        "job_title": {
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
        },
        "last_name": {
          "type": "keyword"
        },
        "uid": {
          "type": "keyword"
        }
      }
    },
    "category": {
      "type": "keyword"
    },
    "content": {
      "type": "text"
    },
    "locale": {
      "type": "keyword"
    },
    "publish_date": {
      "type": "date",
      "format": "iso8601"
    },
    "tags": {
      "properties": {
        "elastic_stack": {
          "type": "keyword"
        },
        "industry": {
          "type": "keyword"
        },
        "level": {
          "type": "keyword"
        },
        "product": {
          "type": "keyword"
        },
        "tags": {
          "type": "keyword"
        },
        "topic": {
          "type": "keyword"
        },
        "use_case": {
          "type": "keyword"
        },
        "use_cases": {
          "type": "keyword"
        }
      }
    },
    "title": {
      "type": "text"
    },
    "url": {
      "type": "keyword"
    }
  }
}

POST _reindex
{
  "source": {
    "index": "blogs"
  }, 
  "dest": {
    "index": "blogs_fixed"
  }
}
```

- The reindex request will take a few moments, but should run fairly quickly. If it times out, do not panic and *do not run the reindex command again*.
- It just means it took more than 1 minute, and Console stopped waiting for the response. The request will continue to run in the background though.
- 기존 인덱스를 기반으로 다른 인덱스에 문서를 저장하는 명령어를 위와같이 사용한다.

1. Run the following command to see how many documents are in `blogs_fixed`. You will know the reindexing is complete when `blogs_fixed` has 4,719 documents.

```jsx
GET blogs_fixed/_count
```

1. Run the previous query for "security analytics" on the original `blogs` index. You should get 598 hits. Why are there so many more hits?

```jsx
GET blogs/_search
{
  "query": {
    "match": {
      "tags.use_case": "security analytics"
    }
  }
}

hits -> 216

GET blogs_fixed/_search
{
  "query": {
    "match": {
      "tags.use_case": "security analytics"
    }
  }
}

hits -> 598
```

- 왜 새로 생성된 인덱스는 다른 결과를 나타낼까?
- blogs 인덱스의 tags.use_case 같은 경우

```jsx
"use_cases" : {
              "type" : "text",
              "fields" : {
                "keyword" : {
                  "type" : "keyword",
                  "ignore_above" : 256
                }
              }
```

- blog_fixed 인덱스의 tags.use_case 같은 경우

```jsx
"use_case" : {
              "type" : "keyword"
            },
```

- blogs 인덱스의 tags.use_case가 잘못 설계되었다고 생각할 수 있지만 저런 식으로 하나의 필드에 여러 인덱싱 방식을 적용할 수 있다.

```jsx
{
  "title": {
    "type": "text",
    "fields": {
      "keyword": {
        "type": "keyword"
      }
    }
  }
}
```

title
title.keyword

- 이렇게 두 개의 필드가 생기고 두 필드의 용도는 다르다.

| 필드 | 용도 |
| --- | --- |
| title | full-text search |
| title.keyword | 정렬 / aggregation |

### 2.3 Text analysis

1. Elasticsearch provides an `_analyze` API. For example, to see what would happen to the string `"United Kingdom"` if you applied the `standard` analyzer, you can use the following in Console:

```jsx
GET _analyze
{
  "text": "United Kingdom",
  "analyzer": "standard"
}
```

response 

```jsx
{
  "tokens" : [
    {
      "token" : "united",
      "start_offset" : 0,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "kingdom",
      "start_offset" : 7,
      "end_offset" : 14,
      "type" : "<ALPHANUM>",
      "position" : 1
    }
  ]
}
```

- 분석을 진행한 경우 대문자는 소문자로 변환되는 것을 확인할 수 있다.
- 그리고 띄어쓰기 단위로 잘라진 것을 확인할 수 있다.

1. Let's take a closer look at analyzers. Compare the output of the `_analyze` API on the string `"Nodes and Shards"` using the `standard` analyzer and using the `english` analyzer.

```jsx
GET _analyze
{
  "text": "Nodes and Shards",
  "analyzer": "standard"
}

---- response ----
{
  "tokens" : [
    {
      "token" : "nodes",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "and",
      "start_offset" : 6,
      "end_offset" : 9,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "shards",
      "start_offset" : 10,
      "end_offset" : 16,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}

GET _analyze
{
  "text": "Nodes and Shards",
  "analyzer": "english"
}

---- response ----
{
  "tokens" : [
    {
      "token" : "node",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "shard",
      "start_offset" : 10,
      "end_offset" : 16,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}

```

- 각 analyzer 마다 텍스트를 분석하는 것이 다릅니다.
    - stopword 삭제 여부
    - 소문자 변환 수행

<stop word?>

```jsx
and
the
a
is
in
of
```

- 의미 전달에 크게 기여하지 않는 단어

1. Using the `_analyze` API, see what the `standard` analyzer does with the following HTML snippet:

```jsx
GET _analyze
{
  "analyzer": "standard",
  "text":     "<b>Is</b> this <a href='/blogs'>clean</a> text?"
}
```

```jsx
{
  "tokens" : [
    {
      "token" : "b",
      "start_offset" : 1,
      "end_offset" : 2,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "b",
      "start_offset" : 7,
      "end_offset" : 8,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "href",
      "start_offset" : 18,
      "end_offset" : 22,
      "type" : "<ALPHANUM>",
      "position" : 5
    },
    {
      "token" : "blog",
      "start_offset" : 25,
      "end_offset" : 30,
      "type" : "<ALPHANUM>",
      "position" : 6
    },
    {
      "token" : "clean",
      "start_offset" : 32,
      "end_offset" : 37,
      "type" : "<ALPHANUM>",
      "position" : 7
    },
    {
      "token" : "text",
      "start_offset" : 42,
      "end_offset" : 46,
      "type" : "<ALPHANUM>",
      "position" : 9
    }
  ]
}
```

- HTML 태그도 일반 텍스트처럼 인덱싱됨.
- elastic search는 기본적으로 HTML을 이해하지 못합니다.

1. **EXAM PREP:** The `html_strip` character filter strips out HTML code before indexing the data. As a result, you will have cleaner data to search against. To use this filter, you need to create a custom analyzer. Create a new index named `blogs_test` that defines an `analyzer` named `content_analyzer` that uses:
- the `html_strip` character filter
- the `standard` tokenizer
- the `lowercase` filter

- 따라서 custom analyzer를 만들어서 문제를 해결하는 방식으로 진행할 수 있다.

```jsx
PUT blogs_test
{
  "settings": {
    "analysis": {
      "analyzer": {
        "content_analyzer" : {
          "tokenizer" : "standard",
          "filter" : ["lowercase"],
          "char_filter" : ["html_strip"]
        }
      }
    }
  }
}
```

- blogs_test라는 인덱스에 “content_analyzer” 라는 analyzer 를 생성.

```jsx
GET blogs_test/_analyze
{
  "text": "<b>Is</b> this <a href='/blogs'>clean</a> text?",
  "analyzer": "content_analyzer"
}
```

```jsx
{
  "tokens" : [
    {
      "token" : "is",
      "start_offset" : 3,
      "end_offset" : 9,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "this",
      "start_offset" : 10,
      "end_offset" : 14,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "clean",
      "start_offset" : 32,
      "end_offset" : 41,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "text",
      "start_offset" : 42,
      "end_offset" : 46,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}
```

### 2.4 Types and parameters

1. In the previous lab, you changed the `tags` fields (`tags.elastic_stack`, `tags.industry`, `tags.level`, etc.) into `keyword` fields. Querying all these separate fields is possible, but not optimal. Let's copy all the individual `tags` fields into one `search_tags` field that can be queried with a simple `match` query. At the same time, let's also apply the `content_analyzer` to the `content` field.
    - create a new index named `blogs_fixed2`. Use the mapping and settings of `blogs_fixed` as the starting point
    - add a new `keyword` field to the `blogs_fixed2` mapping named `search_tags`
    - using `copy_to`, copy the values of all the `tags` to `search_tags`
    - disable doc values for the new `search_tags` field (it will not be used for sorting or aggregations)
    - completely disable the `authors.uid` field
    - apply the custom `content_analyzer` from lab 2.3 to the `content` field (don't forget that the analyzer needs to be defined in the settings!)

```jsx
PUT blogs_fixed2
{
  "settings": {
    "analysis": {
      "analyzer": {
        "content_analyzer": {
          "tokenizer": "standard",
          "filter": ["lowercase"],
          "char_filter": ["html_strip"]
        }
      }
    }
  },
  "mappings": {
    "_meta": {
      "created_by": "Elastic Student"
    },
    "properties": {
      "authors": {
        "properties": {
          "company": {
            "type": "text",
            "fields": {
              "keyword": {
                "type": "keyword",
                "ignore_above": 256
              }
            }
          },
          "first_name": {
            "type": "keyword"
          },
          "full_name": {
            "type": "text"
          },
          "job_title": {
            "type": "text",
            "fields": {
              "keyword": {
                "type": "keyword",
                "ignore_above": 256
              }
            }
          },
          "last_name": {
            "type": "keyword"
          },
          "uid": {
            "enabled": false
          }
        }
      },
      "category": {
        "type": "keyword"
      },
      "content": {
        "type": "text",
        "analyzer": "content_analyzer"
      },
      "locale": {
        "type": "keyword"
      },
      "publish_date": {
        "type": "date",
        "format": "iso8601"
      },
      "search_tags": {
        "type": "keyword",
        "doc_values": false
      },
      "tags": {
        "properties": {
          "elastic_stack": {
            "type": "keyword",
            **"copy_to": "search_tags"  -- ! --**
          },
          "industry": {
            "type": "keyword",
            **"copy_to": "search_tags"  -- ! --**
          },
          "level": {
            "type": "keyword",
            **"copy_to": "search_tags"  -- ! --**
          },
          "product": {
            "type": "keyword",
            **"copy_to": "search_tags"  -- ! --**
          },
          "tags": {
            "type": "keyword",
            **"copy_to": "search_tags"  -- ! --**
          },
          "topic": {
            "type": "keyword",
            **"copy_to": "search_tags"  -- ! --**
          },
          "use_case": {
            "type": "keyword",
            **"copy_to": "search_tags"  -- ! --** 
          },
          "use_cases": {
            "type": "keyword",
            **"copy_to": "search_tags"  -- ! --** 
          }
        }
      },
      "title": {
        "type": "text"
      },
      "url": {
        "type": "keyword"
      }
    }
  }
}

```

- 코드를 보면 **"copy_to": "search_tags" 를 tags 하위 필드에서 볼 수 있는데 즉 여러 필드의 값을 search_tags 라는 하나의 필드로 복사해서 그 필드 하나만을 검색하도록 만드는 것이다.**

- 따라서 아래와 같은 요청을 날릴 수 있다.

```jsx
GET blogs_fixed2/_search
{
  "query": {
    "match": {
      "search_tags": "logstash"
    }
  }
}
```

- 즉 모든 tag.~ 필드를 한 번에 검색하는 효과이다.

1. Run the following aggregation on the `search_tags` field:

```jsx
GET blogs_fixed2/_search
{
  "size": 0,
  "aggs": {
    "top_job_titles": {
      "terms": {
        "field": "search_tags",
        "size": 10
      }
    }
  }
}
```

- The `search_tags` field does not have doc values enabled. As a result, you cannot aggregate on that field. ⇒ error
    - copy to로 생성한 값은 통계를 진행할 수 없다.

1. Run the following aggregation on the `authors.uid` field:

```jsx
GET blogs_fixed2/_search
{
  "size": 0,
  "aggs": {
    "top_author_uids": {
      "terms": {
        "field": "authors.uid",
        "size": 10
      }
    }
  }
}
```

⇒ 결과 없음 ⇒ 

- The `authors.uid` field has been disabled. From a query and aggregation perspective, it's as if that field does not exist.
- "enabled": false ⇒ 맵핑 진행 시 해당 값을 주게되면 검색이나 집계에서는 그 필드가 없는 것처럼 동작한다.

```jsx
"authors": {
  "properties": {
    "uid": {
      "type": "keyword",
      ***"enabled": false***
    }
  }
}
```

### 3.1 Searching with the QueryDSL
