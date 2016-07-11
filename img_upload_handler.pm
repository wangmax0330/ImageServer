package img_upload_handler;
use Time::Local;
use nginx;
use MongoDB;
use MongoDB::OID;
use FileHandle;

sub process {
       my $request = shift;
    if ($request ->request_method ne "POST") {
        return DECLINED;
    }
    if ($request ->has_request_body(\&post)) {
        return OK;
    }
    return HTTP_BAD_REQUEST;
}
sub post {
    my $request = shift;
    $request ->send_http_header("text/html");
    $request ->print("<meta charset=\"utf8\">");

    my $args = $request->args;
    my $type_postion = index($args,"type=",1);
    my $type= substr($args,$type_postion+5);    
	
    my  @arr = split("form-data; name=\"",$request ->request_body);
	my %hash = (1,2,3,4); #初始化

	for(my $i=1;$i<@arr;$i++){
		my $start_postion = index(@arr[$i],"\"",1);
		my $end_postion = index(@arr[$i],"------",$start_postion+1);
		my $val = substr(@arr[$i],$start_postion+1,$end_postion-$start_postion-1);
		$val=~ s/\s//g;
		$hash{substr(@arr[$i],0,$start_postion)} = $val;
	}
      
#文件存储
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	$mon++; $year +=1900;

	# 存储名称
	my $new_name = time();
    $hash{"file_name"}=~s/\S+\./$new_name\./;
    $new_name= $hash{"file_name"};      
    
	# 读取文件
    my $file = $hash{"file_path"};
	open(MYFILE,"$file") or die;
    my @len  = sysread(MYFILE,$file_data,10240000);
	
	# 连接数据库
    my $client = MongoDB::MongoClient->new;
    my $db = $client->get_database('user');
    my $collection = $db->get_collection("stu");
    
	my $full_path = "$type/$year/$mon/$mday/$hour/$min/$new_name";

    # 存入数据库
    $id =  $collection->insert({fullpath=>"$full_path",
								type=>"$type",
								year=>"$year",
								mon=>"$mon",
								day=>"$mday",
								hour=>"$hour",
								min=>"$min",
								name=>"$new_name",
								filedata=>"$file_data"});
								
    $request->print("http://IP/$full_path");
    return OK;
}


1;

