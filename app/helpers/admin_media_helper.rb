module AdminMediaHelper

  #  -------- CURRENTLY UNUSED -------- #

  # establish a connection to S3

  AWS::S3::Base.establish_connection!(:access_key_id => Setting.get('aws_access_key_id'), :secret_access_key => Setting.get('aws_secret_access_key'))
  BUCKET = Setting.get('aws_bucket_name')


  # Returns a url to the file from S3
  # Params:
  # +key+:: string to the file

  def download_url_for(key)
    AWS::S3::S3Object.url_for(key, BUCKET, :authenticated => false)
  end


  # Returns a block of html
  # Params:
  # +initial+:: is the initial iteration true/false

  def render_folder_loop(initial = false)

    files = Media.setup_and_search_posts

    @initial = initial
    @f = Array.new

    files.each_with_index do |item, index|
      if item.content_type != 'binary/octet-stream'
        next
      end

      @f.push item
    end
    # render the html
    render :partial => 'admin/media/media_folder_loop'

  end


  # Create a folder tree of the directories on S3.
  # This is complicated as S3 returns the data as a string.
  # Params:
  # +fulldata+:: array of all of the data
  # +nextalong+:: the next data along
  # +i+:: counter which has been set from the front end html

  def make_media_folder_subpage(fulldata, nextalong, i, y = false)

    hasFolder = false

    if !fulldata[i+2].blank?
      if fulldata[i+1].key.count('/') < fulldata[i+2].key.count('/')
        # check to see if it has a folder. This is so the system knows wether to
        # make another iteration
        hasFolder = true
      end
    end

    file = fulldata[i+1]
    name = file.key.split("/").last

    if !y
      html = '<ul>'
    end

    # add li for the folder
    html += "<li class='folderRow'>
<a class='folderLink' href='' data-key='#{file.key}' data-hasfolder='#{hasFolder}'>
<i class='icon-folder-close'></i>&nbsp;<span>#{name}</span>
<i class='icon-remove'></i></a>"

    # if full data plus two is not blank make another iteration
    if !fulldata[i+2].blank?

      if fulldata[i+1].key.count('/') < fulldata[i+2].key.count('/')
        html += make_media_folder_subpage fulldata, fulldata[i+1], i+1
      end

    end

    html += "</li>"

    if !y
      html += '</ul>'
    end

    return html.html_safe

  end

end
