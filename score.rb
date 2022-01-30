# This program performs some basic analysis on 'five_letter_words.txt' to try
# to determine what a good wordle guess would be.

puts 'Reading words ... '
words = IO.read('valid_words.txt')
  .lines
  .map(&:strip)
puts "Total raw words: #{words.count}"

puts 'Counting frequency ...'
letter_freq = words
  .each_with_object({}) do |w, hash|
    ('a'..'z').each do |l|
      hash[l] ||= 0
      hash[l] += 1 if w.count(l) > 0
    end

    hash
  end.each_with_object({}) do |(l, occ), hash|
    hash[l] = occ.to_f / words.count
    hash
  end
pp letter_freq.sort

puts 'Scoring words ...'
words_scored = words
  .each_with_object({}) do |w, hash|
    hash[w] = w.chars.map{|c| letter_freq[c]}.sum
  end

words_with_uniq_letters_sorted = words_scored.reject{|w| w.chars.uniq.length < 5 }.sort_by{|w, score| -score }
puts 'Saving ...'
File.open('scored_words.txt', 'w') {|f| words_with_uniq_letters_sorted.each{|w, score| f.puts "#{w} #{score}" } }

best_starting_words = words_with_uniq_letters_sorted.select{|w, score| score > 1.5 }
File.open('best_words.txt', 'w') {|f| best_starting_words.each{|w, score| f.puts w } }

puts "Recommended: #{best_starting_words.sample.first}"
