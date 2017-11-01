<?php
class ModelAccountUnionlogin extends Model {
	public function addUnionLoginInfo($data) {
		$this->db->query("INSERT INTO " . DB_PREFIX . "union_login SET  related_customer_id = '" . $this->db->escape($data['related_customer_id']) . "', remote_key = '" . $this->db->escape($data['remote_key']) . "', remote_from = '" . $this->db->escape($data['remote_from']) . "', date_added = NOW()");
		$union_loing_id = $this->db->getLastId();
		return $union_loing_id;
	}

	public function getByRemoteKey($remoteKey) {
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "union_login WHERE remote_key = '" . $this->db->escape($remoteKey) . "' AND remote_key != ''");
		return $query->row;
	}
}
