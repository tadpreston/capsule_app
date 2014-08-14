describe API::V1::SearchesController do
  before do
    api_setup
  end

  describe 'GET "index"' do
    it 'returns success' do
      get :index, { query: 'hi' }
      expect(response).to be_success
    end

    context "query has a '#'" do
      it 'searches for hashtags' do
        expect(Capsule).to receive(:search_hashtags).with('#hashtag')
        get :index, { query: '#hashtag' }
      end
    end

    context "query has a '@'" do
      it 'searches by identity' do
        expect(Users::Search).to receive(:by_identity).with('@joesmith')
        get :index, { query: '@joesmith' }
        expect(Users::Search).to receive(:by_identity).with('hello @joesmith buy')
        get :index, { query: 'hello @joesmith buy' }
        expect(Users::Search).to receive(:by_identity).with('joesmith@email.com')
        get :index, { query: 'joesmith@email.com' }
        expect(Users::Search).to receive(:by_identity).with('hello joesmith@email.com buy')
        get :index, { query: 'hello joesmith@email.com buy' }
      end
    end

    context "query is only alphanumeric" do
      it "searches for all" do
        expect(Capsule).to receive(:search_capsules).with('this is a test', kind_of(User))
        expect(Capsule).to receive(:search_hashtags).with('this is a test')
        expect(Users::Search).to receive(:by_name).with('this is a test')
        get :index, { query: 'this is a test' }
      end
    end
  end
end
