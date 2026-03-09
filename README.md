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
