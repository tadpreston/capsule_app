require 'spec_helper'

describe Location::GeoBox do

  describe 'coordinates over north america' do
    let(:lat) { 37.178181 }
    let(:long) { -96.054581 }
    let(:lat_span) { 1.03245 }
    let(:long_span) { 1.10987 }

    before { @geo_box = Location::GeoBox.new(lat, long, lat_span, long_span) }

    it 'should initialize' do
      expect(@geo_box).to be_a(Location::GeoBox)
    end

    it 'the range should have 1 longitude' do
      expect(@geo_box.range[:west_long]).to be_a(Float)
      expect(@geo_box.range[:east_long]).to be_a(Float)
    end

    it 'returns the correct values' do
      expect(@geo_box.range[:north_lat]).to eq(lat)
      expect(@geo_box.range[:south_lat]).to eq(lat - lat_span)
      expect(@geo_box.range[:west_long]).to eq(long)
      expect(@geo_box.range[:east_long]).to eq(long + long_span)
    end
  end

  describe 'coordinates that cross the equator' do
    let(:lat) { 7.178181 }
    let(:long) { -96.054581 }
    let(:lat_span) { 10.03245 }
    let(:long_span) { 10.10987 }

    before { @geo_box = Location::GeoBox.new(lat, long, lat_span, long_span) }

    it 'should initialize' do
      expect(@geo_box).to be_a(Location::GeoBox)
    end

    it 'returns the correct values' do
      expect(@geo_box.range[:north_lat]).to eq(lat)
      expect(@geo_box.range[:south_lat]).to eq(lat - lat_span)
      expect(@geo_box.range[:west_long]).to eq(long)
      expect(@geo_box.range[:east_long]).to eq(long + long_span)
    end
  end

  describe 'cooridinates that span the prime meridian at Greenwich' do
    let(:lat) { 7.178181 }
    let(:long) { -6.054581 }
    let(:lat_span) { 10.03245 }
    let(:long_span) { 10.10987 }

    before { @geo_box = Location::GeoBox.new(lat, long, lat_span, long_span) }

    it 'should initialize' do
      expect(@geo_box).to be_a(Location::GeoBox)
    end

    it 'returns the correct values' do
      expect(@geo_box.range[:north_lat]).to eq(lat)
      expect(@geo_box.range[:south_lat]).to eq(lat - lat_span)
      expect(@geo_box.range[:west_long]).to eq(long)
      expect(@geo_box.range[:east_long]).to eq(long + long_span)
    end
  end

  describe 'cooridinates that span the prime meridian at 180 degrees' do
    let(:lat) { 7.178181 }
    let(:long) { 175.054581 }
    let(:lat_span) { 10.03245 }
    let(:long_span) { 30.10987 }

    before { @geo_box = Location::GeoBox.new(lat, long, lat_span, long_span) }

    it 'should initialize' do
      expect(@geo_box).to be_a(Location::GeoBox)
      expect(@geo_box.range[:west_long]).to be_an(Array)
      expect(@geo_box.range[:east_long]).to be_an(Array)
    end

    it 'returns the correct values' do
      expect(@geo_box.range[:north_lat]).to eq(lat)
      expect(@geo_box.range[:south_lat]).to eq(lat - lat_span)
      expect(@geo_box.range[:west_long]).to eq([long, 180])
      expect(@geo_box.range[:east_long]).to eq([-180, (long + long_span - 360)])
    end
  end

  describe 'south latitude that spans more than it should' do
    it 'returns the south_lat as -90' do
      geo_box = Location::GeoBox.new(-80.43256, -93.23455, 32.4345, 32.59023)
      expect(geo_box.range[:south_lat]).to eq(-90)
    end
  end

  describe 'Coordinates with a radius' do
    describe 'coordinates over north america' do
      let(:lat) { 37.178181 }
      let(:long) { -96.054581 }
      let(:radius) { 1.03245 }

      before { @geo_box = Location::GeoBox.new(lat, long, radius) }

      it 'should initialize' do
        expect(@geo_box).to be_a(Location::GeoBox)
      end

      it 'the range should have 1 longitude' do
        expect(@geo_box.range[:west_long]).to be_a(Float)
        expect(@geo_box.range[:east_long]).to be_a(Float)
      end

      it 'returns the correct values' do
        expect(@geo_box.range[:north_lat]).to eq(lat + radius)
        expect(@geo_box.range[:south_lat].round(7)).to eq((lat - radius).round(7))
        expect(@geo_box.range[:west_long]).to eq(long - radius)
        expect(@geo_box.range[:east_long]).to eq(long + radius)
      end
    end

    describe 'latitude that crosses boundries' do
      describe 'radius crosses equator' do
        let(:lat) { 7.178181 }
        let(:long) { -96.054581 }
        let(:radius) { 10.03245 }

        before { @geo_box = Location::GeoBox.new(lat, long, radius) }

        it 'returns a latitude that spans the equator' do
          expect(@geo_box.range[:north_lat]).to eq(lat + radius)
          expect(@geo_box.range[:south_lat].round(7)).to eq((lat - radius).round(7))
        end
      end

      describe 'the span casues the latitude to be greater than 90' do
        it 'returns north_latitude as 90' do
          geo_box = Location::GeoBox.new(85.23445, -96.0533, 20.33422)
          expect(geo_box.range[:north_lat]).to eq(90)
        end
      end

      describe 'the span casues the latitude to be less than -90' do
        it 'returns south_latitude as -90' do
          geo_box = Location::GeoBox.new(-85.23445, -96.0533, 20.33422)
          expect(geo_box.range[:south_lat]).to eq(-90)
        end
      end
    end
  end

  describe 'to_where to generate a where clause for sql' do
    it 'returns with single lat and long range clause' do
      geo_box = Location::GeoBox.new(37.178, -96.054, 1.032, 1.109)
      comp_where = 'latitude BETWEEN 36.146 AND 37.178 AND longitude BETWEEN -96.054 AND -94.94500000000001'
      expect(geo_box.to_where).to eq(comp_where)
    end

    it 'returns with single lat and two long range clause' do
      geo_box = Location::GeoBox.new(37.178, 178.054, 10.032, 10.109)
      comp_where = 'latitude BETWEEN 27.145999999999997 AND 37.178 AND (longitude BETWEEN 178.054 AND 180) OR (longitude BETWEEN -180 AND -171.837)'
      expect(geo_box.to_where).to eq(comp_where)
    end
  end
end
