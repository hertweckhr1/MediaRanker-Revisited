require 'test_helper'

describe WorksController do
  describe "root" do
    it "succeeds with all media types" do
      # Precondition: there is at least one media of each category

    end

    it "succeeds with one media type absent" do
      # Precondition: there is at least one media in two of the categories

    end

    it "succeeds with no media" do

    end
  end

  CATEGORIES = %w(album book movie)
  INVALID_CATEGORIES = ["nope", "42", "", "  ", "albumstrailingtext"]

  describe "index" do
    it "succeeds when there are works" do
      get works_path

      must_respond_with :success
    end

    it "succeeds when there are no works" do
      Work.destroy_all

      get works_path

      must_respond_with :success
    end
  end

  describe "new" do
    it "succeeds" do
      get new_work_path

      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a work with valid data for a real category" do
      work_hash = {
        work: {
          title: "Light in the Attic",
          creator: "Shell Silverstein",
          description: "Chidrens classic poems",
          category: "book",
          publication_year: 1995

        }
      }
      expect {
        post works_path, params: work_hash
      }.must_change 'Work.count', 1

      must_respond_with :redirect
      new_book_created = Work.find_by(title: work_hash[:work][:title])
      expect(new_book_created.title).must_equal work_hash[:work][:title]
      expect(new_book_created.creator).must_equal work_hash[:work][:creator]
      expect(new_book_created.description).must_equal work_hash[:work][:description]
      expect(new_book_created.publication_year).must_equal work_hash[:work][:publication_year]
      expect(new_book_created.category).must_equal work_hash[:work][:category]
    end

    it "renders bad_request and does not update the DB for bogus data" do
      work_hash = {
        new_book: {
          creator: "Shell Silverstein",
          description: "Chidrens classic poems",
          publication_year: "1995",
          category: CATEGORIES[1]
        }
      }

      expect {
        post works_path, params: work_hash
      }.wont_change 'Work.count'

      must_respond_with :bad_request
    end

    it "renders 400 bad_request for bogus categories" do
      work_hash = {
        new_book: {
          creator: "Shell Silverstein",
          description: "Chidrens classic poems",
          publication_year: "1995",
          category: "sandwiches"
        }
      }

      expect {
        post works_path, params: work_hash
      }.wont_change 'Work.count'

      must_respond_with :bad_request
    end

  end

  describe "show" do
    it "succeeds for an extant work ID" do
      id = works(:album).id

      get work_path(id)

      must_respond_with :success
    end

    it "renders 404 not_found for a bogus work ID" do
      get work_path(-1)

      must_respond_with :not_found

    end
  end

  describe "edit" do
    it "succeeds for an extant work ID" do
      id = works(:album).id

      get edit_work_path(id)

      must_respond_with :success
    end

    it "renders 404 not_found for a bogus work ID" do
      get edit_work_path(-1)

      must_respond_with :not_found
    end
  end

  describe "update" do
    it "succeeds for valid data and an extant work ID" do
      id = works(:album).id
      work_hash = {
        work: {
          title: "New Title",
          creator: "You Create",
          description: "This is an older album",
          publication_year: 1955,
          category: "album"
        }
      }
      
      expect {
        patch work_path(id), params: work_hash
      }.wont_change 'Work.count'
      binding.pry
      # must_respond_with :redirect

      new_album = Work.find_by(id: id)
      expect(new_album.title).must_equal work_hash[:work][:title]
      expect(new_album.creator).must_equal work_hash[:work][:creator]
      expect(new_album.description).must_equal work_hash[:work][:description]
      expect(new_album.publication_year).must_equal work_hash[:work][:publication_year]
      expect(new_album.category).must_equal work_hash[:work][:category]
    end

    it "renders bad_request for bogus data" do

    end

    it "renders 404 not_found for a bogus work ID" do

    end
  end

  describe "destroy" do
    it "succeeds for an extant work ID" do

    end

    it "renders 404 not_found and does not update the DB for a bogus work ID" do

    end
  end

  describe "upvote" do

    it "redirects to the work page if no user is logged in" do

    end

    it "redirects to the work page after the user has logged out" do

    end

    it "succeeds for a logged-in user and a fresh user-vote pair" do

    end

    it "redirects to the work page if the user has already voted for that work" do

    end
  end
end
