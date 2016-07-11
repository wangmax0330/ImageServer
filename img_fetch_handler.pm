package img_fetch_handler;
use Time::Local;
use nginx;
use MongoDB;
use MongoDB::OID;
use FileHandle;

sub image{
    my $request = shift;
    
	# 连接数据库
    my $client = MongoDB::MongoClient->new;
    my $db = $client->get_database('user');
    my $users = $db->get_collection("stu");
	
	# 
    my $url = $request->uri;
    my $full_path = substr($url,1);
	
	# 根据全路径查找图片
    my $cursor = $users->find({fullpath=>"$full_path"});
    my $obj = $cursor->next;
#    my $name = $obj->{name}; 
#    my $_id = $obj->{_id};	

    my $file_data = $obj->{filedata};    
	if($file_data)	{
	       	$request ->send_http_header("image/jpeg");
        	$request->print($file_data);
	}else{
		my $filepath = "/etc/$full_path";
		open(MYFILE,"$filepath");
		sysread(MYFILE,$filea,10240000);
		if($filea){
			$request ->send_http_header("image/jpeg");
			$request->print($filea);
		}else{
				$request ->send_http_header("text/html");
				$request ->print("<meta charset=\"utf8\">");
				$request->print("file not found!");
		}
    }
    return OK;
}

1;
