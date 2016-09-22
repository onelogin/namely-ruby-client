shared_examples "a resource with an index metadata action" do |instance_methods = []|
  it 'behaves like open struct' do
    VCR.use_cassette("#{subject.endpoint}_index_metadata") do
      metadata = subject.metadata

      expect(metadata).to be_an OpenStruct
    end
  end

  it "returns index metadata" do
    VCR.use_cassette("#{subject.endpoint}_index_metadata") do
      metadata = subject.metadata

      expect(metadata).to be_an OpenStruct
      instance_methods.each do |instance_method|
        expect(metadata).to respond_to instance_method
      end
    end
  end

  it 'returns total amount of resources but not the requested amount' do
    VCR.use_cassette("#{subject.endpoint}_index_metadata") do
      metadata = subject.metadata

      expect(metadata.count).to be > 1
    end
  end
end
