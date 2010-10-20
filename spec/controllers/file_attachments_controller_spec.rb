require 'spec_helper'

describe FileAttachmentsController do
  def flash_now 
    controller.instance_eval{flash.stub!(:sweep)} 
  end

  def mock_file_attachment
    @mock_file_attachment ||= mock_model(FileAttachment, 
      :uploaded_file => some_file, :filepath= => nil, :name => 'what', :save => true)
  end

  def some_file
    fixture_file_upload(File.join(Rails.root.to_s, 'spec', 'fixtures', 'somefile.txt'), 'text/plain')
  end

  describe "when logged in as admin" do
    before do
      FileAttachment.stub(:new).and_return(mock_file_attachment)
      @params = { :description => "blah blah", :name => "agenda",
        :uploaded_file => some_file }
    end
    
    context "http upload" do
      context "no file is selected for upload" do
        it "redirects to the home page if no file was uploaded" do
          post :create, :file_attachment => {}
          response.should redirect_to(root_path(:std => 1))
        end
        it "sets a flash[:warning]" do
          post :create, :file_attachment => {}
          flash[:warning].should_not be_nil
        end
      end
      it "should upload a new file attachment with an event" do
        pending
        FileAttachment.should_receive(:new).and_return(mock_file_attachment)
        post :create, :file_attachment => @params
        #response.should redirect_to(event_url(:std => 1))
      end
      it "should upload a new file attachment without an event" do
        # @params.merge!(:event_id => '')
        mock_file = mock_model(FileAttachment, @params.merge({:save => nil, :errors => mock('Error', {:full_messages => []})}))
        FileAttachment.should_receive(:new).and_return(mock_file)
        post :create, :file_attachment => @params
      end
      it "should save the new file attachment" do
        mock_file_attachment.should_receive(:save)
        post :create, :file_attachment => @params
      end
      it "when file is attached to event, redirect to the event page" do
        pending
        post :create, :file_attachment => @params
        #response.should redirect_to event_path(@mock_file_attachment.event.id, :std => 1)
      end
      it "when file is not attached, redirect to the file attachments page" do
        mock_file = mock_model(FileAttachment, {
          :uploaded_file => some_file, :filepath => nil, :name => 'what',
          :save => true
        })
        FileAttachment.stub(:new).and_return(mock_file)
        post :create, :file_attachment => @params
        response.should redirect_to root_path(:std => 1)
      end
    end
    
    context "plupload" do
      
      before(:each) do
        @params.delete(:name) && @params.delete(:description)
      end
      
      it "should upload a new file attachment with an event" do
        FileAttachment.should_receive(:new).and_return(mock_file_attachment)
        
        post :create, {
          :file => some_file
        }
        
        assigns[:file_attachment].should == mock_file_attachment
        
        response.should render_template('file_attachments/_file_attachment')
      end
      
      it "should upload a new file attachment without an event" do
        post :create, {
          :file => some_file
        }
        
        assigns[:file_attachment].should == mock_file_attachment
      end
    end
    
    context "delete a file" do
      
      before(:each) do
        FileAttachment.stub(:find).and_return(mock_file_attachment)
        mock_file_attachment.stub(:full_path).and_return(File.join(Rails.root.to_s, 'spec', 'fixtures', 'somefile.txt'))
        mock_file_attachment.stub(:destroy).and_return(mock_file_attachment)
        File.stub(:rm)
      end
      
      it "load the file attachment" do
        FileAttachment.should_receive(:find).and_return(mock_file_attachment)
        post :destroy, :id => 1
        assigns[:file_attachment].should == mock_file_attachment
      end
      
      it "destroys the file attachment" do
        mock_file_attachment.should_receive(:destroy)
        post :destroy, :id => 1
      end
      
      it "sets a flash[:notice]" do
        post :destroy, :id => 1
        flash[:notice].should_not be_nil
      end
      
    end

  end
  
  describe "when Errno::ENOENT is raised" do
    
    before(:each) do
      FileAttachment.stub(:find).and_return(mock_file_attachment)
      mock_file_attachment.stub(:destroy).and_raise(Errno::ENOENT.new("File not found"))
    end
    
    it "logs the error" do
      controller.logger.should_receive(:error).with("FileAttachmentsController[destroy] was rescued with :file_not_found. No such file or directory - File not found")
      post :destroy, :id => 1
    end
    
    it "sets a flash[:warning]" do
      post :destroy, :id => 1
      flash[:warning].should_not be_nil
    end
    
  end
  
  describe ":edit, :id => integer" do
    
    before(:each) do
      FileAttachment.stub(:find).and_return(mock_file_attachment)
    end
    
    it "loads a file_attachment as @file_attachment" do
      FileAttachment.should_receive(:find).with('1').and_return(mock_file_attachment)
      get :edit, :id => "1"
      assigns[:file_attachment].should == @mock_file_attachment
    end
    
  end
  
  describe ":update, :id => integer, :file_attachment => {}" do
    
    before(:each) do
      FileAttachment.stub(:find).and_return(mock_file_attachment)
      mock_file_attachment.stub(:update_attributes).and_return(nil)
    end
    
    it "loads a file attachment" do
      FileAttachment.should_receive(:find).with('1').and_return(@mock_file_attachment)
      put :update, :id => "1"
      assigns[:file_attachment].should == @mock_file_attachment
    end
  
    it "updates the file attachment" do
      @mock_file_attachment.should_receive(:update_attributes).with({
        'description' => 'some lovely new description',
        'name' => 'slightly.modified.txt'
      }).and_return(nil)
      put :update, :id => 1, :file_attachment => {
        :description => 'some lovely new description',
        :name => 'slightly.modified.txt'
      }
    end
  
    context "update succeeds (std HTML POST:)" do
    
      before(:each) do
        @mock_file_attachment.stub(:update_attributes).and_return(true)
      end
    
      it "sets a flash[:notice]" do
        put :update, :id => "1"
        flash[:notice].should_not be_nil
      end
    
      it "redirects to index or event for file" do
        pending
        put :update, :id => "1"
        #response.should redirect_to(event_path(mock_event.id))
      end
    
    end
  
    context "update fails (std HTML POST):" do
    
      before(:each) do
        flash_now
        @mock_file_attachment.stub(:update_attributes).and_return(false)
      end
    
      it "sets a flash[:warning]" do
        put :update, :id => "1"
        flash[:warning].should_not be_nil
      end
    
      it "renders the edit template" do
        put :update, :id => "1"
        response.should render_template('file_attachments/edit')
      end
      
    end
    
    context "xhr POST" do
      it "renders the update template" do
        xhr :put, :update, :id => "1"
        response.should render_template("file_attachments/update")
      end
    end
    
  end
  
  describe ":download, :id => required" do
    before(:each) do
      mock_file_attachment.stub(:full_path).and_return(File.join(Rails.root.to_s, 'spec', 'fixtures', 'somefile.txt'))
      FileAttachment.stub(:find).and_return(mock_file_attachment)
    end
    it ":download, :id => required" do
      controller.stub(:render)
      controller.should_receive(:send_data).with(
        File.new(File.join(Rails.root.to_s, 'spec', 'fixtures', 'somefile.txt')).read,
        :filename => 'somefile.txt',
        :stream => true,
        :buffer_size => 1.megabyte
      )
      get :download, :id => mock_file_attachment.id
    end
  end

end
