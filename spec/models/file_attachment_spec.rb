require 'spec_helper'

describe FileAttachment do

  include ActionDispatch::TestProcess # for fixture_file_upload

  before(:each) do
    File.stub(:open)
    @path = File.join(Rails.root.to_s, 'public', 'files', 'general')
    @full_path = File.join(@path, 'somefile.txt')
    @trash_path = File.join(@path, 'trash', 'somefile.txt')

    @file_attachment = FileAttachment.new({
      :description => 'unique description',
      :uploaded_file => fixture_file_upload(File.join(Rails.root.to_s, 'spec', 'fixtures', 'somefile.txt'), 'text/plain')
    })
    @file_attachment.valid? # force build_filepath
  end

  it "should generate a unique name" do
    File.stub(:open)
    File.stub(:exists?).with("#{@path}/somefile.txt"){ true }
    File.stub(:exists?).with("#{@path}/somefile-1.txt"){ false }
    File.should_receive(:open).with("#{@path}/somefile-1.txt", "wb").at_least(:once)
    new_file = FileAttachment.create({
      :description => 'other description',
      :uploaded_file => fixture_file_upload(File.join(Rails.root.to_s, 'spec', 'fixtures', 'somefile.txt'), 'text/plain')
    })
  end
  
  it "should know whether its file actually exists" do
    File.stub(:exists?).with("#{@path}/somefile.txt"){ true }
    @file_attachment.file_saved?.should be_true
    File.stub(:exists?).with("#{@path}/somefile.txt"){ false }
    @file_attachment.file_saved?.should be_false
  end
  
  it "should move its file to the trash when destroyed" do
    @file_attachment.should_receive(:move_file_to_trash_folder!)
    @file_attachment.destroy
  end
  
  it "should know how to throw files into the trash" do
    @file_attachment.stub(:generate_unique_filename){ "somefile.txt" }
    File.stub(:exists?){ true }
    FileUtils.should_receive(:mv).with(@full_path, @trash_path)
    @file_attachment.send(:move_file_to_trash_folder!)
  end
  
  it "should be able to create a folder name that mirrors the attachable_type and attachable_id" do
    @file_attachment.send(:attachable_folder).should eq "general"
    module Blog; class Post; extend ActiveModel::Naming; def self.base_class; Blog::Post; end end end
    blog_post = mock_model(Blog::Post)
    @file_attachment.attachable = blog_post
    @file_attachment.send(:attachable_folder).should eq "blog/post/#{blog_post.id}"
    
    class Event; extend ActiveModel::Naming; def self.base_class; Event; end end
    event = mock_model(Event)
    @file_attachment.attachable = event
    @file_attachment.send(:attachable_folder).should eq "event/#{event.id}"
  end
  
  it "should ensure that the destination folder exists" do
    FileUtils.should_receive(:mkdir_p).with(@path)
    @file_attachment.send(:ensure_folder_path_exists)
  end
  
  context "should be able to update filepath in db & fs" do
    before(:each) do
      @old_path = File.join "files", "somefile.txt"
      @file_attachment.filepath = @old_path
      FileUtils.stub(:mv).with("#{Rails.root}/public/#{@old_path}", @full_path)
    end
    it "update the fs" do
      FileUtils.should_receive(:mv).with("#{Rails.root}/public/#{@old_path}", @full_path)
      @file_attachment.update_filepath
    end
    context "fs update succeeds :)" do
      it "update the db" do
        p "stubbing obj under test"
        @file_attachment.stub(:file_saved?){ true }
        @file_attachment.should_receive(:save)
        @file_attachment.update_filepath
      end
    end
    context "fs update fails :(" do
      before(:each) do
        @file_attachment.stub(:file_saved?){ false }
      end
      it "add error to base" do
        p "stubbing obj under test"
        @file_attachment.errors.should_receive(:add).with(:base, "Error updating filepath for #{@file_attachment.name}")
        @file_attachment.update_filepath
      end
      it "return false" do
        p "stubbing obj under test"
        @file_attachment.update_filepath.should be_false
      end
    end
  end
end
