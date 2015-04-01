#генерирую appserver.config для mssql
sub gen_appserver_mssql{
	my $base_name = "BASE_NAME";
	if(defined($_[0])){
		$base_name = $_[0];
	}

	my $dir = ".";
	if(defined($_[1])){
		$dir = $_[1];
	}

	my $file = "appserver.config";
	if(defined($_[2])){
		$file = $_[2];
	}

	open(FILE, "> ".File::Spec->catfile($dir, $file));

	print FILE '<?xml version="1.0" encoding="windows-1251"?>
<server-config xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<database>
		<provider>MSSQL</provider>
		<work-db-connection-string>Data Source=(local)\SQLEXPRESS;Initial Catalog='.$base_name.';Integrated Security=True;Connect Timeout=1800</work-db-connection-string>
	</database>

	<server-mode>Native</server-mode>

	<logging>
		<loggers>
			<logger type="Parus.Net.Logger.StandardStores.ConsoleLogStore, AppServer.Common">
				<filter-level>Normal</filter-level>
			</logger>
			<logger type="Parus.Net.Logger.StandardStores.TextFileLogStore, AppServer.Common">
				<filter-level>Minimal</filter-level>
				<params>
					<item key="path" value=".\Tornado_Log\" />
					<item key="period" value="daily" />
					<item key="size" value="1000000" />
				</params>
			</logger>
		</loggers>
	</logging>
	<security-config>
		<role-groups>
			<role-group role="User" group-name="Пользователи"/>
			<role-group role="ServerAdministrator" group-name="Администраторы"/>
			<role-group role="ServerAdministrator" group-name="Administrators"/>
		</role-groups>
	</security-config>

	<storage>
		<path>C:\ProgramData\Parus.TornadoServer.PerformanceBefore</path>
	</storage>
</server-config>';
	close FILE;
}

#генерирую appserver.config для postgre
sub gen_appserver_postgre{
	my $base_name = "BASE_NAME";
	if(defined($_[0])){
		$base_name = $_[0];
	}
	
	my $admin_name = "ADMIN_NAME";
	if(defined($_[1])){
		$admin_name = $_[1];
	}
	
	my $pass = "PASS";
	if(defined($_[2])){
		$pass = $_[2];
	}

	my $dir = ".";
	if(defined($_[3])){
		$dir = $_[3];
	}
	
	my $file = "appserver.config";
	if(defined($_[4])){
		$file = $_[4];
	}

	open(FILE, "> ".File::Spec->catfile($dir, $file));

	print FILE '<?xml version="1.0" encoding="windows-1251"?>
<server-config xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<database>
		<provider>PostgreSQL</provider>	
		<work-db-connection-string>Server=localhost;Port=5432;UserId='.$admin_name.';Password='.$pass.';Database='.$base_name.';Pooling=True;MinPoolSize=10;MaxPoolSize=200</work-db-connection-string>
	</database>

	<server-mode>Native</server-mode>

	<logging>
		<loggers>
			<logger type="Parus.Net.Logger.StandardStores.ConsoleLogStore, AppServer.Common">
				<filter-level>Normal</filter-level>
			</logger>
			<logger type="Parus.Net.Logger.StandardStores.TextFileLogStore, AppServer.Common">
				<filter-level>Minimal</filter-level>
				<params>
					<item key="path" value=".\Tornado_Log\" />
					<item key="period" value="daily" />
					<item key="size" value="1000000" />
				</params>
			</logger>
		</loggers>
	</logging>
	<security-config>
		<role-groups>
			<role-group role="User" group-name="Пользователи"/>
			<role-group role="ServerAdministrator" group-name="Администраторы"/>
			<role-group role="ServerAdministrator" group-name="Administrators"/>
		</role-groups>
	</security-config>

	<storage>
		<path>C:\ProgramData\Parus.TornadoServer.PerformanceBefore</path>
	</storage>
</server-config>
';
	close FILE;
}


1;