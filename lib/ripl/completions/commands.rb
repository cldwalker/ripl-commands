complete(:method=>'config') {
  (Ripl::Shell::OPTIONS.keys + Ripl.config.keys).uniq -
    [:irbrc, :riplrc, :history, :completion, :readline]
}
