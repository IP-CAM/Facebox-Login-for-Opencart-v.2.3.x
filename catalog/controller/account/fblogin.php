<?php
class ControllerAccountFblogin extends Controller {
	private $error = array();

    public function validate() {
        ob_start();
        $this->load->model('account/customer');
        $this->load->model('account/unionlogin');
        $this->load->model('account/address');
        $fuid =  $this->request->post['uid'];
        if(empty($fuid)){

        }
        $email = empty($this->request->post['email']) ? $fuid.'@'.'facebook.com' : $this->request->post['email'];
        //获取关联信息用户信息
        $unionlogin = $this->model_account_unionlogin->getByRemoteKey($fuid);
        // 如果已经绑定过本地用户信息时， 获取本地用户信息，并且直接登录
        if($unionlogin){
            $customer_id = $unionlogin['related_customer_id'];
            $customer = $this->model_account_customer->getCustomer($customer_id);
        }
        // 绑定关联信息
        else{
            // 如果邮箱已被注册需要修改
            $tem = $this->model_account_customer->getCustomerByEmail($email);
            if(!empty($tem)){
                list($name,$host) = explode('@',$email);
                $email = $name. rand('100','999').'@'.$host;
            }
            // 插入用户信息
            $param = array(
                'name'=>'F_'.$this->request->post['name'],
                'password'=>$fuid,  //已键值作为密码
                'email'=>$email,
                'firstname'=>$this->request->post['first_name'],
                'lastname'=>$this->request->post['last_name'],
            );
            $customer_id = $this->model_account_customer->addCustomer($param);
            // 插入绑定关联信息
            $param = array(
                'related_customer_id'=>$customer_id,
                'remote_key'=>$fuid,
                'remote_from'=>'facebook',
            );
            $this->model_account_unionlogin->addUnionLoginInfo($param);
            $customer = $this->model_account_customer->getCustomer($customer_id);
        }

        $email = $customer['email'];
        if ($this->customer->login($email, $fuid,true)) {
            //
            $address_id =$customer['address_id'];
            $address = $this->model_account_address->getAddress($address_id);

            if(empty($address['firstname']) || empty($address['lastname'])
                || empty($address['country_id']) || empty($address['zone_id'])
                || empty($address['address_1']) || empty($address['city'])
            ){
                $callback = array(
                    'status'=>'01',
                    'add_id'=>$address_id,
                    'url'=>$this->url->link('account/address/edit&address_id='.$address_id),
                    //'url'=>$this->url->link('account/address/edit','address_id='.$address_id,true),
                );
            }
            else{
                $callback = array('status'=>'02');
            }
        }
        else{
            $callback = array('status'=>'00');
        }
        ob_end_clean();

        $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($callback));
	}
}
