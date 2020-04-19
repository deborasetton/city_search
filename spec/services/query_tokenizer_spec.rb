RSpec.describe QueryTokenizer do
  describe '.call' do
    describe 'converts non-ASCII characters to ASCII approximations' do
      test_cases = {
        'Montréal' => ['Montreal'],
        'São Paulo' => ['Sao', 'Paulo'],
        'Los Álamos' => ['Los', 'Alamos'],
      }

      test_cases.each do |input, output|
        specify "#{input} => #{output}" do
          expect(described_class.call(input)).to eq output
        end
      end
    end

    describe 'splits input string by configured delimiters' do
      test_cases = {
        'Jacksonville, Florida, US' => ['Jacksonville', 'Florida', 'US'],
        'Jacksonville,Florida,US' => ['Jacksonville', 'Florida', 'US'],
        'Cape Breton-Sydney ,   Nova Scotia,CA' => ['Cape', 'Breton-Sydney', 'Nova', 'Scotia', 'CA'],
      }

      test_cases.each do |input, output|
        specify "#{input} => #{output}" do
          expect(described_class.call(input)).to eq output
        end
      end
    end
  end
end
