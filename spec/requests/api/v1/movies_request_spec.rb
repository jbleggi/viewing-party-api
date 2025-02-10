# bundle exec rspec spec/requests/api/v1/movies_request_spec.rb

require 'rails_helper'

RSpec.describe "Movie endpoints", type: :request do
  describe "GET #index" do
    it "retrieves 20 top rated movies", :vcr do
      get "/api/v1/movies"
      
      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to be_a Hash
      expect(json[:data].count).to eq 20

      json[:data].each do |movie|
        expect(movie[:attributes]).to have_key :title
        expect(movie[:attributes]).to have_key :vote_average
      end
    end

    it "handles errors gracefully" do 
    end
  end

  describe "GET #search" do
    it "retrieves results based on search params" do 
      search_term = "lord of the rings"

      get("/api/v1/movies/search?query=#{search_term})")
  
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(json).to be_a Hash
      expect(json[:data].count).to be <= 20

      json[:data].each do |movie|
        expect(movie[:attributes]).to have_key :title
        expect(movie[:attributes]).to have_key :vote_average
      end
    end

    it "handles errors gracefully" do 
    end
  end

  describe "GET #show" do 
    before do 
      movie_id = 278

      stub_request(:get, "https://api.themoviedb.org/3/movie/#{movie_id}")
        .to_return(status: 200, body: movie_details_response.to_json, headers: { 'Content-Type' => 'application/json' })

      expected_movie_details = {
        "data" => {
            "id": "278",
            "type": "movie",
            "attributes": {
                "title": "The Shawshank Redemption",
                "release_year": "1994",
                "vote_average": 8.7,
                "runtime": 142,
                "genres": [
                    "Drama",
                    "Crime"
                ],
                "summary": "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
                "cast": [
                    {
                        "character": "Andy Dufresne",
                        "actor": "Tim Robbins"
                    },
                    {
                        "character": "Ellis Boyd 'Red' Redding",
                        "actor": "Morgan Freeman"
                    },
                    {
                        "character": "Warden Norton",
                        "actor": "Bob Gunton"
                    },
                    {
                        "character": "Heywood",
                        "actor": "William Sadler"
                    },
                    {
                        "character": "Captain Byron T. Hadley",
                        "actor": "Clancy Brown"
                    },
                    {
                        "character": "Tommy",
                        "actor": "Gil Bellows"
                    },
                    {
                        "character": "Brooks Hatlen",
                        "actor": "James Whitmore"
                    },
                    {
                        "character": "Bogs Diamond",
                        "actor": "Mark Rolston"
                    },
                    {
                        "character": "1946 D.A.",
                        "actor": "Jeffrey DeMunn"
                    },
                    {
                        "character": "Skeet",
                        "actor": "Larry Brandenburg"
                    }
                ],
                "total_reviews": 17,
                "reviews": [
                    {
                        "author": "elshaarawy",
                        "review": "very good movie 9.5/10 محمد الشعراوى"
                    },
                    {
                        "author": "John Chard",
                        "review": "Some birds aren't meant to be caged.\r\n\r\nThe Shawshank Redemption is written and directed by Frank Darabont. It is an adaptation of the Stephen King novella Rita Hayworth and Shawshank Redemption. Starring Tim Robbins and Morgan Freeman, the film portrays the story of Andy Dufresne (Robbins), a banker who is sentenced to two life sentences at Shawshank State Prison for apparently murdering his wife and her lover. Andy finds it tough going but finds solace in the friendship he forms with fellow inmate Ellis \"Red\" Redding (Freeman). While things start to pick up when the warden finds Andy a prison job more befitting his talents as a banker. However, the arrival of another inmate is going to vastly change things for all of them.\r\n\r\nThere was no fanfare or bunting put out for the release of the film back in 94, with a title that didn't give much inkling to anyone about what it was about, and with Columbia Pictures unsure how to market it, Shawshank Redemption barely registered at the box office. However, come Academy Award time the film received several nominations, and although it won none, it stirred up interest in the film for its home entertainment release. The rest, as they say, is history. For the film finally found an audience that saw the film propelled to almost mythical proportions as an endearing modern day classic. Something that has delighted its fans, whilst simultaneously baffling its detractors. One thing is for sure, though, is that which ever side of the Shawshank fence you sit on, the film continues to gather new fans and simply will never go away or loose that mythical status.\r\n\r\nIt's possibly the simplicity of it all that sends some haters of the film into cinematic spasms. The implausible plot and an apparent sentimental edge that makes a nonsense of prison life, are but two chief complaints from those that dislike the film with a passion. Yet when characters are this richly drawn, and so movingly performed, it strikes me as churlish to do down a human drama that's dealing in hope, friendship and faith. The sentimental aspect is indeed there, but that acts as a counterpoint to the suffering, degradation and shattering of the soul involving our protagonist. Cosy prison life you say? No chance. The need for human connection is never more needed than during incarceration, surely? And given the quite terrific performances of Robbins (never better) & Freeman (sublimely making it easy), it's the easiest thing in the world to warm to Andy and Red.\r\n\r\nThose in support aren't faring too bad either. Bob Gunton is coiled spring smarm as Warden Norton, James Whitmore is heart achingly great as the \"Birdman Of Shawshank,\" Clancy Brown is menacing as antagonist Capt. Byron Hadley, William Sadler amusing as Heywood & Mark Rolston is impressively vile as Bogs Diamond. Then there's Roger Deakins' lush cinematography as the camera gracefully glides in and out of the prison offering almost ethereal hope to our characters (yes, they are ours). The music pings in conjunction with the emotional flow of the movie too. Thomas Newman's score is mostly piano based, dovetailing neatly with Andy's state of mind, while the excellently selected soundtrack ranges from the likes of Hank Williams to the gorgeous Le Nozze di Figaro by Mozart.\r\n\r\nIf you love Shawshank then it's a love that lasts a lifetime. Every viewing brings the same array of emotions - anger - revilement - happiness - sadness - inspiration and a warmth that can reduce the most hardened into misty eyed wonderment. Above all else, though, Shawshank offers hope - not just for characters in a movie - but for a better life and a better world for all of us. 10/10"
                    },
                    {
                        "author": "tmdb73913433",
                        "review": "Make way for the best film ever made people. **Make way.**"
                    },
                    {
                        "author": "thommo_nz",
                        "review": "There is a reason why this movie is at the top of any popular list your will find.\r\nVery strong performances from lead actors and a story line from the literary brilliance of Stephen King (and no, its not a horror).\r\nSufficient drama and depth to keep you interested and occupied without stupefying your brain. It is the movie that has something for everyone."
                    },
                    {
                        "author": "Andrew Gentry",
                        "review": "It's still puzzling to me why this movie exactly continues to appear in every single best-movies-of-all-time chart. There's a great story, perfect cast, and acting. It really moves me in times when I'm finding myself figuring out things with my annual tax routine reading <a href=\"https://www.buzzfeed.com/davidsmithjd/what-is-form-w-2-and-how-does-it-work-3n31d\">this article</a>, and accidentally catching myself wondering what my life should be if circumstances had changed so drastically. This movie worth a rewatch by all means, but yet, there's no unique vibe or something - there are thousands of other ones as good as this one."
                    }
                ]
            } } } 
    end

    it "returns details about a movie" do 
      get "/movies/#{movie_id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['id']).to eq(movie_id.to_s)
      expect(json['data']['type']).to eq('movie')

      expect(json['data']['attributes']['title']).to eq("The Shawshank Redemption")
      expect(json['data']['attributes']['release_year']).to eq(1994)
      expect(json['data']['attributes']['vote_average']).to eq(8.706)
      expect(json['data']['attributes']['runtime']).to eq("2 hours, 22 minutes")
      expect(json['data']['attributes']['genres']).to eq(["Drama", "Crime"])
      expect(json['data']['attributes']['summary']).to eq("Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison...")

      cast = json['data']['attributes']['cast']
      expect(cast.length).to eq(10)
      expect(cast.first['character']).to eq("Andy Dufresne")
      expect(cast.first['actor']).to eq("Tim Robbins")

      expect(json['data']['attributes']['total_reviews']).to eq(14)

      reviews = json['data']['attributes']['reviews']
      expect(reviews.length).to eq(5)
      expect(reviews.first['author']).to eq("elshaarawy")
      expect(reviews.first['review']).to eq("very good movie 9.5/10 محمد الشعراوى")
    end

    it "handles errors gracefully" do 
    end
  end
end