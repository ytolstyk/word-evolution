class Evolution
  MAX_STRING_LENGTH = 50
  MAX_GENERATIONS = 10_000
  EXIT_STRINGS = ['quit', 'exit']
  ALLOWED_CHARACTERS = ('a'..'z').to_a + [' ']

  attr_accessor :target_species, :initial_species

  def initialize
    @initial_species = ''
    run
  end

  def run
    while true
      puts 'Input a string up to 30 characters long:'
      @target_species = gets.chomp.to_s.downcase

      return if EXIT_STRINGS.include?(@string)

      if valid?(target_species)
        break
      else
        puts 'The string must have only letters or spaces and be less than 30 characters long'
      end
    end

    generate_initial_species
    evolve
  end

  def valid?(string)
    string.length <= MAX_STRING_LENGTH && string.split('').all? { |letter| ALLOWED_CHARACTERS.include?(letter) }
  end

  def generate_initial_species
    @initial_species = [].tap do |initial_array|
      target_species.length.times do |i|
        initial_array << ALLOWED_CHARACTERS.sample
      end
    end.join

    puts "\nGenerated initial species: #{initial_species}"
    puts "Beginning evolution...\n"
  end

  def evolve
    num_generations = 0

    while target_species != initial_species
      differential_indices.each do |index|
        mutate_at_index(index)
      end

      num_generations += 1
      if num_generations % 10 == 0
        puts "\n Generation #{num_generations}: #{initial_species}"
      else
        print '.'
      end

      if num_generations > MAX_GENERATIONS
        evolution_failed = true
        break
      end
    end

    if evolution_failed
      puts "\nThe species became extinct after #{num_generations} generations at #{initial_species}.\n"
    else
      puts "\nReached target species after #{num_generations}.\n"
    end
  end

  def differential_indices
    [].tap do |indices|
      initial_species.length.times do |index|
        indices << index if initial_species[index] != target_species[index]
      end
    end
  end

  def mutate_at_index(index)
    initial_species[index] = ALLOWED_CHARACTERS.sample
  end
end

if __FILE__ == $PROGRAM_NAME
  Evolution.new
end
