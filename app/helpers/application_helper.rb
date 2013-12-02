module ApplicationHelper
	# Returns the full title on a per-page basis
	def full_title(page_title)
		base_title = "Chalkbag"
		if page_title.empty?
			base_title
		else
			"#{nase_title} | #{page_title}"
		end
	end
end
