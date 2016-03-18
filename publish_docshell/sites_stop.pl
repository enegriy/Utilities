use warnings;
use strict;
use File::Spec;
use Encode qw(decode encode);

# Спрашиваем о намерениях
print "Do you want STOP docshell site? y - <<Yes>>, n - <<No>>"."\n";
my $answer = <STDIN>;
chomp $answer;

if($answer eq 'y')
{
	# Путь к серверу
	my $path_to_server = "\\\\192.168.15.15\\c\$";

	# Имя файла
	my $file_name = "App_offline.htm";

	# Пути к сайтам DocShell
	my @docshell_sites = ("inetpub\\auth", "inetpub\\my", "inetpub\\wwwroot\\DocShell");

	# Содержимое файла
	my $file_content = decode('UTF-8', '<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			<title>Производится обслуживание сайта</title>
			<style>
				body {
					margin:           0;
					font-family:      "Helvetica Neue", Helvetica, Arial, sans-serif;
					font-size:        14px;
					line-height:      20px;
					color:            #333333;
					background-color: #ffffff;
				}

				.container {
					padding-right: 20px;
					padding-left:  20px;
					*zoom:         1;
				}

				.row {
					width: 100%;
					*zoom: 1;
				}

				h1 {
					margin: 10px 0;
					font-family: inherit;
					font-weight: bold;
					line-height: 20px;
					color: inherit;
					text-rendering: optimizelegibility;
					line-height: 40px;
					font-size: 38.5px;
				}

				.center {text-align: center; margin-left: auto; margin-right: auto; margin-bottom: auto; margin-top: auto;}

				.hero-unit {
					padding:               60px;
					margin-top:            20px;
					margin-bottom:         30px;
					font-size:             18px;
					font-weight:           200;
					line-height:           30px;
					color:                 inherit;
					background-color:      #eeeeee;
					-webkit-border-radius: 6px;
					-moz-border-radius:    6px;
					border-radius:         6px;
				}

				hr {
				  margin: 20px 0;
				  border: 0;
				  border-top: 1px solid #eeeeee;
				  border-bottom: 1px solid #ffffff;
				}

				.hero-unit h1 {
				  margin-bottom: 0;
				  font-size: 60px;
				  line-height: 1;
				  letter-spacing: -1px;
				  color: inherit;
				}

				.btn {
				  display: inline-block;
				  *display: inline;
				  padding: 4px 12px;
				  margin-bottom: 0;
				  *margin-left: .3em;
				  font-size: 14px;
				  line-height: 20px;
				  color: #333333;
				  text-align: center;
				  text-shadow: 0 1px 1px rgba(255, 255, 255, 0.75);
				  vertical-align: middle;
				  cursor: pointer;
				  background-color: #f5f5f5;
				  *background-color: #e6e6e6;
				  background-image: -moz-linear-gradient(top, #ffffff, #e6e6e6);
				  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#ffffff), to(#e6e6e6));
				  background-image: -webkit-linear-gradient(top, #ffffff, #e6e6e6);
				  background-image: -o-linear-gradient(top, #ffffff, #e6e6e6);
				  background-image: linear-gradient(to bottom, #ffffff, #e6e6e6);
				  background-repeat: repeat-x;
				  border: 1px solid #cccccc;
				  *border: 0;
				  border-color: #e6e6e6 #e6e6e6 #bfbfbf;
				  border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
				  border-bottom-color: #b3b3b3;
				  -webkit-border-radius: 4px;
					 -moz-border-radius: 4px;
						  border-radius: 4px;
				  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr="#ffffffff", endColorstr="#ffe6e6e6", GradientType=0);
				  filter: progid:DXImageTransform.Microsoft.gradient(enabled=false);
				  *zoom: 1;
				  -webkit-box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
					 -moz-box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
						  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
				}

				.btn:hover,
				.btn:focus,
				.btn:active,
				.btn.active,
				.btn.disabled,
				.btn[disabled] {
				  color: #333333;
				  background-color: #e6e6e6;
				  *background-color: #d9d9d9;
				}

				.btn:hover,
				.btn:focus {
				  color: #333333;
				  text-decoration: none;
				  background-position: 0 -15px;
				  -webkit-transition: background-position 0.1s linear;
					 -moz-transition: background-position 0.1s linear;
					   -o-transition: background-position 0.1s linear;
						  transition: background-position 0.1s linear;
				}

				.btn.active,
				.btn:active {
				  background-image: none;
				  outline: 0;
				  -webkit-box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.15), 0 1px 2px rgba(0, 0, 0, 0.05);
					 -moz-box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.15), 0 1px 2px rgba(0, 0, 0, 0.05);
						  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.15), 0 1px 2px rgba(0, 0, 0, 0.05);
				}

				a.btn {
					text-decoration: none;
				}
			</style>

		</head>

		<body>
			<div class="container">
				<div class="row">
					<div class="hero-unit center">
						<h1>Сайт DocShell временно недоступен</h1>
						<hr/>
						<p>Мы выполняем обновление сайта и в настоящий момент он недоступен.</p>
						<!--<p><b>Или вы можете нажать на кнопку:</b></p>

						<a href="/" class="btn btn-large btn-primary">Перейти на главную страницу</a>-->
					</div>
				</div>
			</div>

		</body>
	</html>');

	print "Please waite while Docshell sites will been stoping"."\n";

	# Останавливаю сайты
	foreach my $site(@docshell_sites)
	{	
		open  FILE, ">:encoding(UTF-8)",File::Spec->catfile($path_to_server, $site, $file_name);
		print FILE $file_content;
		close FILE;
		
		print "Stoped \"$site\" was success"."\n";
	}
}




