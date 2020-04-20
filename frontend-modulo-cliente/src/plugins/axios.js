import Vue from 'vue';
import axios from 'axios'; 
import router from './../router/index';

axios.defaults.baseURL = 'http://nsbhospedagemweb.com/DPC/index.php';

Vue.use({
    install(Vue){
        Vue.prototype.$http = axios;
    }
});

axios.interceptors.request.use(function (config) {  
  
  //if(localStorage.getItem("token_dpc")!="null")
  //  config.headers['Authorization'] = `Token ${localStorage.getItem("token_dpc")}`;
    
    config.headers["Access-Control-Allow-Origin", "*"]; 
    config.headers["Access-Control-Allow-Credentials", "true"]; 
    config.headers["Access-Control-Allow-Methods", "*"]; 
    config.headers["Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept"];
    return config;
  }, function (error) {
    return Promise.reject(error);
  });

axios.interceptors.response.use( config => {
    if(config.request.status === 200){
      //alert('Sucesso');
    }  
    return config;
  }, error => {
    if(error.request.status === 401){
      localStorage.setItem("token_dpc",null);
      router.push({name: 'login', params:{isRedirect: true}},{});
    }
    if(error.request.status === 500){
      console.log(error)
    }    
    return Promise.reject(error);
  });