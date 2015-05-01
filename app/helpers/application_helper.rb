module ApplicationHelper
  @@english_stop_words ||= %w{a able about across after all almost also am among an and any are as at be because been but by can cannot could dear did do does either else ever every for from get got had has have he her hers him his how however i if in into is it its just least let like likely may me might most must my neither no nor not of off often on only or other our own rather said say says she should since so some than that the their them then there these they this tis to too twas us wants was we were what when where which while who whom why will with would yet you your }

  def word_frequency(string)
    words = string.gsub(/[^a-zA-Z\s\d]/,'').split(' ')
    frequency = Hash.new(0)
    words.each { |word| frequency[word.downcase] += 1 }

    max_count = frequency.values.max
    #min_count = words.values.min

    freq_array = []
    frequency.each { |k,v| freq_array << [k,v] unless (v<2 || k.length<=2 || is_a_number?(k) || k.in?(@@english_stop_words)) }

    frequency_cutoff=2
    while freq_array.length > 20 do
      freq_array=freq_array.delete_if { |x| x[1] <= frequency_cutoff }
      frequency_cutoff+=1
    end

    return freq_array  #.sort{|a,b| b[1] <=> a[1]}
  end

  def is_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  def calc_rel(minmax, val)
    min,max=minmax.map{|x| x.to_f}
    range = max-min
    adjfactor = range > 100 ? (100.0/range) : 1.0
    strt = 50.0 - ((range*adjfactor)/2.0)

    return strt + (val*adjfactor)
  end



  # returns the not-highlighted class name unless the text contains the em tag (used for hightlighting)
  def not_highlighted_class?(text)
    'not-highlighted' unless text.match(/<em>.*<\/em>/)
  end

  # we use the following in the menu.coffee.erb file in order to build the fields menu of the QueryBuilder
  def fields_menu
    sorted_fields = Settings.query_fields.sort { |a, b| a[1]['label'] <=> b[1]['label'] }
    sorted_fields.unshift ['_all', { 'label' => 'ANY Field' }]
    menu = {}
    Hash[*sorted_fields.flatten].each do |k, v|
      menu[k] = { 'name' => v['label'] }
    end
    menu
  end

end
