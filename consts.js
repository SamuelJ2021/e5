host1 = '10.51.4.100';
host2 = 'localhost';
host = host1;
user = 'samuel';
password1 = 'samuel';
password = password1;
module.exports = {
    get_info: function() {
       var infos = new Map();
       infos.set("host", host);
       infos.set("password", password);
       infos.set("user", user)
       
       return infos;
    }
 }