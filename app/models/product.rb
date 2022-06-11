class Product < ActiveRecord::Base	
 	def self.import(file)
	 	chunks = SmarterCSV.process(
		  file.path,
		  {
		    user_provided_headers: [:name, :category],
		    headers_in_file: false, :col_sep => "\t",
		    chunk_size: ENV.fetch('CHUNK_SIZE', 1000).to_i
		  }
		)
		chunks.each do |data_attrs|
	  	Product.create!(data_attrs)
	  end
	end

	def self.search(search_for)
    Appointment.where('name LIKE ?', "%#{search_for}%")
	end
end