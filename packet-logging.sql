# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
# ULOGD v2 SQL Logging Scheme
# inspired by: https://git.netfilter.org/ulogd2/tree/doc/
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

# CREATE/UPDATE STRUCTURE
SET foreign_key_checks = 0;

# tables
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

# Dummy View to allow ulogd2 to retieve output fields...workaround..
# -----------------------------------------------------------------------
DROP VIEW IF EXISTS `ulogd2_fields`;
CREATE VIEW `ulogd2_fields` AS
    SELECT
        NULL as _id,

        NULL as oob_time_sec,
        NULL as oob_time_usec,
        NULL as oob_hook,
        NULL as oob_prefix,
        NULL as oob_mark,
        NULL as oob_in,
        NULL as oob_out,
        NULL as oob_family,
        NULL as oob_protocol,

        NULL as ip_saddr_bin,
        NULL as ip_daddr_bin,
        NULL as ip_protocol,
        NULL as ip_tos,
        NULL as ip_ttl,
        NULL as ip_totlen,
        NULL as ip_ihl,
        NULL as ip_csum,
        NULL as ip_id,
        NULL as ip_fragoff,
        
        NULL as ip6_payloadlen,
        NULL as ip6_priority,
        NULL as ip6_hoplimit,
        NULL as ip6_flowlabel,
        NULL as ip6_fragoff,
        NULL as ip6_fragid,
        
        NULL as tcp_sport,
        NULL as tcp_dport,
        NULL as tcp_seq,
        NULL as tcp_ackseq,
        NULL as tcp_window,
        NULL as tcp_urg,
        NULL as tcp_urgp,
        NULL as tcp_ack,
        NULL as tcp_psh,
        NULL as tcp_rst,
        NULL as tcp_syn,
        NULL as tcp_fin,
        
        NULL as udp_sport,
        NULL as udp_dport,
        NULL as udp_len,
        
        NULL as icmp_type,
        NULL as icmp_code,
        NULL as icmp_echoid,
        NULL as icmp_echoseq,
        NULL as icmp_gateway,
        NULL as icmp_fragmtu,
        
        NULL as icmpv6_type,
        NULL as icmpv6_code,
        NULL as icmpv6_echoid,
        NULL as icmpv6_echoseq,
        NULL as icmpv6_csum,
        
        NULL as sctp_sport,
        NULL as sctp_dport,
        NULL as sctp_csum,

        NULL as raw_label,
        NULL as raw_type,
        #NULL as raw_header,
        NULL as mac_saddr_str,
        NULL as mac_daddr_str
        
        ;

# ip packet logging
# -----------------------------------------------------------------------
DROP TABLE IF EXISTS `packets`;
CREATE TABLE `packets` (
    `_packet_id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `_remote_id` int(10) unsigned default NULL,
    `_mac_id` bigint unsigned default NULL,
    `_prefix_id` int(10) unsigned default NULL,
    `_if_in_id` smallint(5) unsigned default NULL,
    `_if_out_id` smallint(5) unsigned default NULL,
    
    `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP,

    `oob_time_sec` int(10) unsigned default NULL,
    `oob_time_usec` int(10) unsigned default NULL,
    `oob_hook` tinyint(3) unsigned default NULL,
    `oob_mark` int(10) unsigned default NULL,
    `oob_family` tinyint(3) unsigned default NULL,
    
    `ip_saddr` binary(16) default NULL,
    `ip_daddr` binary(16) default NULL,
    `ip_protocol` tinyint(3) unsigned default NULL,
    `ip_tos` tinyint(3) unsigned default NULL,
    `ip_ttl` tinyint(3) unsigned default NULL,
    `ip_totlen` smallint(5) unsigned default NULL,
    `ip_ihl` tinyint(3) unsigned default NULL,
    `ip_csum` smallint(5) unsigned default NULL,
    `ip_id` smallint(5) unsigned default NULL,
    `ip_fragoff` smallint(5) unsigned default NULL,
    
    `ip6_payloadlen` smallint(5) unsigned default NULL,
    `ip6_priority` tinyint(3) unsigned default NULL,
    `ip6_hoplimit` tinyint(3) unsigned default NULL,
    `ip6_flowlabel` int(10) default NULL,
    `ip6_fragoff` smallint(5) default NULL,
    `ip6_fragid` int(10) unsigned default NULL,
    
    `label` tinyint(3) unsigned default NULL,

    PRIMARY KEY `_packet_id` (`_packet_id`),
    KEY `_remote_id` (`_remote_id`),
    KEY `_mac_id` (`_mac_id`),
    KEY `_prefix_id` (`_prefix_id`),
    KEY `_if_in_id` (`_if_in_id`),
    KEY `_if_out_id` (`_if_out_id`),
    KEY `ip_saddr` (`ip_saddr`),
    KEY `ip_daddr` (`ip_daddr`),

    FOREIGN KEY (_remote_id) REFERENCES remotes (_remote_id)
       ON DELETE RESTRICT
       ON UPDATE CASCADE,

    FOREIGN KEY (_mac_id) REFERENCES mac (_mac_id)
       ON DELETE RESTRICT
       ON UPDATE CASCADE,

    FOREIGN KEY (_prefix_id) REFERENCES prefix_types (_prefix_id)
       ON DELETE RESTRICT
       ON UPDATE CASCADE,

    FOREIGN KEY (_if_in_id) REFERENCES interfaces (_interface_id)
       ON DELETE RESTRICT
       ON UPDATE CASCADE,

    FOREIGN KEY (_if_out_id) REFERENCES interfaces (_interface_id)
       ON DELETE RESTRICT
       ON UPDATE CASCADE

) ENGINE=INNODB DEFAULT CHARSET=utf8;

# prefix logging
# -----------------------------------------------------------------------
DROP TABLE IF EXISTS `prefix_types`;
CREATE TABLE `prefix_types` (
    `_prefix_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `prefix` varchar(32) default NULL,

    PRIMARY KEY `_prefix_id` (`_prefix_id`),
    KEY `prefix` (`prefix`)

) ENGINE=INNODB DEFAULT CHARSET=utf8;

# interface logging
# -----------------------------------------------------------------------
DROP TABLE IF EXISTS `interfaces`;
CREATE TABLE `interfaces` (
    `_interface_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
    `interface_name` varchar(32) default NULL,

    PRIMARY KEY `_interface_id` (`_interface_id`),
    KEY `interface_name` (`interface_name`)

) ENGINE=INNODB DEFAULT CHARSET=utf8;

# mac relation logging
# -----------------------------------------------------------------------
DROP TABLE IF EXISTS `mac`;
CREATE TABLE `mac` (
    `_mac_id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `mac_src` varchar(20) default NULL,
    `mac_dst` varchar(20) default NULL,
    `mac_type` smallint(5) unsigned default NULL,

    PRIMARY KEY `_mac_id` (`_mac_id`),
    KEY `mac_addr` (`mac_src`,`mac_dst`,`mac_type`)

) ENGINE=INNODB DEFAULT CHARSET=utf8;

# remote hosts (identified by user@host)
# -----------------------------------------------------------------------
DROP TABLE IF EXISTS `remotes`;
CREATE TABLE `remotes` (
    `_remote_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `user` varchar(50) NOT NULL,

    PRIMARY KEY `_remote_id` (`_remote_id`),
    KEY `user` (`user`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# hardware
# -----------------------------------------------------------------------
DROP TABLE IF EXISTS `hwhdr`;
CREATE TABLE `hwhdr` (
    `_packet_id` bigint unsigned NOT NULL,
    `raw_type` int(10) unsigned default NULL,
    `raw_header` varchar(255) default NULL,

    PRIMARY KEY `_packet_id` (`_packet_id`),
    KEY `raw_type` (`raw_type`),
    KEY `raw_header` (`raw_header`),

    FOREIGN KEY (_packet_id) REFERENCES packets (_packet_id)
       ON DELETE CASCADE
       ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8;

# tcp packages
# -----------------------------------------------------------------------
DROP TABLE IF EXISTS `tcp`;
CREATE TABLE `tcp` (
    `_packet_id` bigint unsigned NOT NULL,
    `tcp_sport` smallint(5) unsigned default NULL,
    `tcp_dport` smallint(5) unsigned default NULL,
    `tcp_seq` int(10) unsigned default NULL,
    `tcp_ackseq` int(10) unsigned default NULL,
    `tcp_window` int(5) unsigned default NULL,
    `tcp_urg` tinyint(1) default NULL,
    `tcp_ack` tinyint(1) default NULL,
    `tcp_psh` tinyint(1) default NULL,
    `tcp_rst` tinyint(1) default NULL,
    `tcp_syn` tinyint(1) default NULL,
    `tcp_fin` tinyint(1) default NULL,

    PRIMARY KEY `_packet_id` (`_packet_id`),
    KEY `tcp_sport` (`tcp_sport`),
    KEY `tcp_dport` (`tcp_dport`),

    FOREIGN KEY (_packet_id) REFERENCES packets (_packet_id)
       ON DELETE CASCADE
       ON UPDATE CASCADE

) ENGINE=INNODB DEFAULT CHARSET=utf8;

# udp packages
# -----------------------------------------------------------------------
DROP TABLE IF EXISTS `udp`;
CREATE TABLE `udp` (
    `_packet_id` bigint unsigned NOT NULL,
    `udp_sport` smallint(5) unsigned default NULL,
    `udp_dport` smallint(5) unsigned default NULL,
    `udp_len` smallint(5) unsigned default NULL,

    PRIMARY KEY `_packet_id` (`_packet_id`),
    KEY `udp_sport` (`udp_sport`),
    KEY `udp_dport` (`udp_dport`),

    FOREIGN KEY (_packet_id) REFERENCES packets (_packet_id)
       ON DELETE CASCADE
       ON UPDATE CASCADE

) ENGINE=INNODB DEFAULT CHARSET=utf8;

# sctp packages
# -----------------------------------------------------------------------
DROP TABLE IF EXISTS `sctp`;
CREATE TABLE `sctp` (
    `_packet_id` bigint unsigned NOT NULL,
    `sctp_sport` smallint(5) unsigned default NULL,
    `sctp_dport` smallint(5) unsigned default NULL,
    `sctp_csum` smallint(5) unsigned default NULL,

    PRIMARY KEY `_packet_id` (`_packet_id`),
    KEY `sctp_sport` (`sctp_sport`),
    KEY `sctp_dport` (`sctp_dport`),

    FOREIGN KEY (_packet_id) REFERENCES packets (_packet_id)
       ON DELETE CASCADE
       ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8;

# icmp v4 packages
# -----------------------------------------------------------------------
DROP TABLE IF EXISTS `icmp`;
CREATE TABLE `icmp` (
    `_packet_id` bigint unsigned NOT NULL,
    `icmp_type` tinyint(3) unsigned default NULL,
    `icmp_code` tinyint(3) unsigned default NULL,
    `icmp_echoid` smallint(5) unsigned default NULL,
    `icmp_echoseq` smallint(5) unsigned default NULL,
    `icmp_gateway` int(10) unsigned default NULL,
    `icmp_fragmtu` smallint(5) unsigned default NULL,

    PRIMARY KEY `_packet_id` (`_packet_id`),

    FOREIGN KEY (_packet_id) REFERENCES packets (_packet_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8;

# icmp v6 packages
# -----------------------------------------------------------------------
DROP TABLE IF EXISTS `icmpv6`;
CREATE TABLE `icmpv6` (
    `_packet_id` bigint unsigned NOT NULL,
    `icmpv6_type` tinyint(3) unsigned default NULL,
    `icmpv6_code` tinyint(3) unsigned default NULL,
    `icmpv6_echoid` smallint(5) unsigned default NULL,
    `icmpv6_echoseq` smallint(5) unsigned default NULL,
    `icmpv6_csum` int(10) unsigned default NULL,

    PRIMARY KEY `_packet_id` (`_packet_id`),
    FOREIGN KEY (_packet_id) REFERENCES packets (_packet_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) ENGINE=INNODB DEFAULT CHARSET=utf8;

# insert procedures/functions
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

# meta packets
# -----------------------------------------------------------------------
DROP FUNCTION IF EXISTS INSERT_IP_PACKET;
delimiter $$
CREATE FUNCTION INSERT_IP_PACKET(
                _remote_id int(10) unsigned,
                _mac_id bigint unsigned,
                _prefix_id int(10) unsigned,
                _if_in_id smallint(5) unsigned,
                _if_out_id smallint(5) unsigned,
                
                _oob_time_sec int(10) unsigned,
                _oob_time_usec int(10) unsigned,
                _oob_hook tinyint(3) unsigned,
                _oob_mark int(10) unsigned,
                _oob_family tinyint(3) unsigned,

                _ip_saddr binary(16),
                _ip_daddr binary(16),
                _ip_protocol tinyint(3) unsigned,
                _ip_tos tinyint(3) unsigned,
                _ip_ttl tinyint(3) unsigned,
                _ip_totlen smallint(5) unsigned,
                _ip_ihl tinyint(3) unsigned,
                _ip_csum smallint(5) unsigned,
                _ip_id smallint(5) unsigned,
                _ip_fragoff smallint(5) unsigned,
                _ip6_payloadlen smallint(5) unsigned,
                _ip6_priority tinyint(3) unsigned,
                _ip6_hoplimit tinyint(3) unsigned,
                _ip6_flowlabel int(10),
                _ip6_fragoff smallint(3),
                _ip6_fragid int(10) unsigned,
                _label tinyint(3) unsigned

                ) RETURNS bigint unsigned
BEGIN


    # insert
    INSERT INTO packets (_remote_id, _mac_id, _prefix_id, _if_in_id, _if_out_id, oob_time_sec, oob_time_usec, oob_hook, oob_mark, oob_family,
                        ip_saddr, ip_daddr, ip_protocol, ip_tos, ip_ttl, ip_totlen, ip_ihl,
                        ip_csum, ip_id, ip_fragoff, ip6_payloadlen, ip6_priority, ip6_hoplimit, ip6_flowlabel,
                        ip6_fragoff, ip6_fragid, label ) 
        VALUES (_remote_id, _mac_id, _prefix_id, _if_in_id, _if_out_id, _oob_time_sec, _oob_time_usec, _oob_hook, _oob_mark, _oob_family,
                _ip_saddr, _ip_daddr, _ip_protocol, _ip_tos, _ip_ttl, _ip_totlen, _ip_ihl,
                _ip_csum, _ip_id, _ip_fragoff, _ip6_payloadlen, _ip6_priority, _ip6_hoplimit, _ip6_flowlabel,
                _ip6_fragoff, _ip6_fragid, _label);

    # Get Packet ID
    RETURN LAST_INSERT_ID();
END
$$
delimiter ;

# TCP PACKETS
# -----------------------------------------------------------------------
DROP PROCEDURE IF EXISTS PACKET_ADD_TCP;
delimiter $$
CREATE PROCEDURE PACKET_ADD_TCP(
        IN `id` bigint unsigned,
        IN `_sport` smallint(5) unsigned,
        IN `_dport` smallint(5) unsigned,
        IN `_seq` int(10) unsigned,
        IN `_ackseq` int(10) unsigned,
        IN `_window` smallint(5) unsigned,
        IN `_urg` tinyint(1),
        IN `_ack` tinyint(1),
        IN `_psh` tinyint(1),
        IN `_rst` tinyint(1),
        IN `_syn` tinyint(1),
        IN `_fin` tinyint(1)
        )
BEGIN
    INSERT INTO tcp (_packet_id, tcp_sport, tcp_dport, tcp_seq, tcp_ackseq, tcp_window, tcp_urg, tcp_ack, tcp_psh, tcp_rst, tcp_syn, tcp_fin) 
        VALUES (id, _sport, _dport, _seq, _ackseq, _window, _urg, _ack, _psh, _rst, _syn, _fin);
END
$$
delimiter ;

# UDP PACKETS
# -----------------------------------------------------------------------
DROP PROCEDURE IF EXISTS PACKET_ADD_UDP;
delimiter $$
CREATE PROCEDURE PACKET_ADD_UDP(
        IN `id` bigint unsigned,
        IN `_sport` smallint(5) unsigned,
        IN `_dport` smallint(5) unsigned,
        IN `_len` smallint(5) unsigned
        )
BEGIN
    INSERT INTO udp (_packet_id, udp_sport, udp_dport, udp_len) 
        VALUES (id, _sport, _dport, _len);
END
$$
delimiter ;

# SCP PACKETS
# -----------------------------------------------------------------------
DROP PROCEDURE IF EXISTS PACKET_ADD_SCTP;
delimiter $$
CREATE PROCEDURE PACKET_ADD_SCTP(
        IN `id` bigint unsigned,
        IN `_sport` smallint(5) unsigned,
        IN `_dport` smallint(5) unsigned,
        IN `_csum` smallint(5) unsigned
        )
BEGIN
    INSERT INTO sctp (_packet_id, sctp_sport, sctp_dport, sctp_csum) 
        VALUES (id, _sport, _dport, _csum);
END
$$
delimiter ;

# ICMP v4 PACKETS
# -----------------------------------------------------------------------
DROP PROCEDURE IF EXISTS PACKET_ADD_ICMP;
delimiter $$
CREATE PROCEDURE PACKET_ADD_ICMP(
        IN `id` bigint unsigned,
        IN `_icmp_type` tinyint(3) unsigned,
        IN `_icmp_code` tinyint(3) unsigned,
        IN `_icmp_echoid` smallint(5) unsigned,
        IN `_icmp_echoseq` smallint(5) unsigned,
        IN `_icmp_gateway` int(10) unsigned,
        IN `_icmp_fragmtu` smallint(5) unsigned
        )
BEGIN
    INSERT INTO icmp (_packet_id, icmp_type, icmp_code, icmp_echoid, icmp_echoseq, icmp_gateway, icmp_fragmtu) 
        VALUES (id, _icmp_type, _icmp_code, _icmp_echoid, _icmp_echoseq, _icmp_gateway, _icmp_fragmtu);

END
$$
delimiter ;

# ICMP v6 PACKETS
# -----------------------------------------------------------------------
DROP PROCEDURE IF EXISTS PACKET_ADD_ICMPV6;
delimiter $$
CREATE PROCEDURE PACKET_ADD_ICMPV6(
        IN `id` bigint unsigned,
        IN `_icmpv6_type` tinyint(3) unsigned,
        IN `_icmpv6_code` tinyint(3) unsigned,
        IN `_icmpv6_echoid` smallint(5) unsigned,
        IN `_icmpv6_echoseq` smallint(5) unsigned,
        IN `_icmpv6_csum` int(10) unsigned
        )
BEGIN
    INSERT INTO icmpv6 (_packet_id, icmpv6_type, icmpv6_code, icmpv6_echoid, icmpv6_echoseq, icmpv6_csum) 
        VALUES (id, _icmpv6_type, _icmpv6_code, _icmpv6_echoid, _icmpv6_echoseq, _icmpv6_csum);
END
$$
delimiter ;

# MAC
# -----------------------------------------------------------------------
DROP FUNCTION IF EXISTS INSERT_OR_SELECT_MAC;
delimiter $$
CREATE FUNCTION INSERT_OR_SELECT_MAC(
        `_saddr` varchar(20),
        `_daddr` varchar(20),
        `_protocol` smallint(5),
        `_raw_type` int(10) unsigned
    ) 
    RETURNS bigint unsigned
    DETERMINISTIC
    MODIFIES SQL DATA
BEGIN
    # local scope!
    DECLARE MAC_ID BIGINT unsigned DEFAULT NULL;

    # STD Packet ? And valid mac (layer 2 traffic) ?
    # ignore routed l3 traffic!
    IF (_raw_type != 1 OR _saddr IS NULL OR _daddr IS NULL) THEN
        RETURN NULL;
    END IF;

    SELECT _mac_id FROM mac WHERE mac_src = _saddr AND mac_dst = _daddr AND mac_type = _protocol LIMIT 1 INTO MAC_ID;

    # entry exists ?
    IF MAC_ID IS NOT NULL THEN
        RETURN MAC_ID;
    ELSE
        INSERT INTO mac (mac_src, mac_dst, mac_type) VALUES (_saddr, _daddr, _protocol);
        RETURN LAST_INSERT_ID();
    END IF;
END
$$
delimiter ;

# PREFIX
# -----------------------------------------------------------------------
DROP FUNCTION IF EXISTS INSERT_OR_SELECT_PREFIX;
delimiter $$
CREATE FUNCTION INSERT_OR_SELECT_PREFIX(
        `_prefix` varchar(32)
    )
    RETURNS int(10) unsigned
    DETERMINISTIC
    MODIFIES SQL DATA
BEGIN
    # local scope!
    DECLARE PF_ID INT(10) unsigned DEFAULT NULL;

    SELECT _prefix_id FROM prefix_types WHERE prefix = _prefix LIMIT 1 INTO PF_ID;
    
    # entry exists ?
    IF PF_ID IS NOT NULL THEN
        RETURN PF_ID;
    ELSE
        INSERT INTO prefix_types (prefix) VALUES (_prefix);
        RETURN LAST_INSERT_ID();
    END IF;
END
$$
delimiter ;

# INTERFACES
# -----------------------------------------------------------------------
DROP FUNCTION IF EXISTS INSERT_OR_SELECT_INTERFACE;
delimiter $$
CREATE FUNCTION INSERT_OR_SELECT_INTERFACE(`oob_if_name` varchar(32))
    RETURNS smallint(5) unsigned
    DETERMINISTIC
    MODIFIES SQL DATA
BEGIN
    # local scope!
    DECLARE IF_ID SMALLINT(5) unsigned DEFAULT NULL;

    SELECT `_interface_id` FROM `interfaces` WHERE `interface_name` = oob_if_name INTO IF_ID;

    # entry exists ?
    IF IF_ID IS NOT NULL THEN
        RETURN IF_ID;
    ELSE
        INSERT INTO `interfaces` (`interface_name`) VALUES (oob_if_name);
        RETURN LAST_INSERT_ID();
    END IF;
END
$$
delimiter ;

# REMOTE
# -----------------------------------------------------------------------
DROP FUNCTION IF EXISTS INSERT_OR_SELECT_REMOTE;
delimiter $$
CREATE FUNCTION INSERT_OR_SELECT_REMOTE(
    ) 
    RETURNS int(10) unsigned
    DETERMINISTIC
    MODIFIES SQL DATA
BEGIN
    # local scope!
    DECLARE REMOTE_ID INT(10) unsigned DEFAULT NULL;

    # get remote_id by current user (multihost logging)
    SELECT `_remote_id` FROM `remotes` WHERE `user`=USER() LIMIT 1 INTO REMOTE_ID;

    # entry exists ?
    IF REMOTE_ID IS NOT NULL THEN
        RETURN REMOTE_ID;
    ELSE
        INSERT INTO `remotes` SET `user`=USER();
        RETURN LAST_INSERT_ID();
    END IF;
END
$$
delimiter ;

# Merge Port View
# -----------------------------------------------------------------------
DROP FUNCTION IF EXISTS JOIN_PORTS;
delimiter $$
CREATE FUNCTION JOIN_PORTS(
        `tcp_port` smallint(5) unsigned,
        `udp_port` smallint(5) unsigned,
        `sctp_port` smallint(5) unsigned
    ) 
    RETURNS smallint(5) unsigned
    DETERMINISTIC
    NO SQL
BEGIN
    IF tcp_port IS NOT NULL THEN
        RETURN tcp_port;
    ELSEIF udp_port IS NOT NULL THEN
        RETURN udp_port;
    ELSEIF sctp_port IS NOT NULL THEN
        RETURN sctp_port;
    ELSE
        RETURN NULL;
    END IF;
END
$$
delimiter ;

# HW HEADER
# -----------------------------------------------------------------------
DROP PROCEDURE IF EXISTS PACKET_ADD_HARDWARE_HEADER;
delimiter $$
CREATE PROCEDURE PACKET_ADD_HARDWARE_HEADER(
        IN `id` bigint unsigned,
        IN `_hw_type` int(10) unsigned,
        IN `_hw_addr` varchar(256)
        )
BEGIN
    INSERT INTO hwhdr (_packet_id, raw_type, raw_header) VALUES
    (id, _hw_type, _hw_addr);
END
$$
delimiter ;

# ULOGD2 Insert Procedure
# -----------------------------------------------------------------------
DROP PROCEDURE IF EXISTS CALL_ULOGD2_INSERT;
delimiter $$
CREATE PROCEDURE CALL_ULOGD2_INSERT(
        IN `_oob_time_sec` int(10) unsigned,
        IN `_oob_time_usec` int(10) unsigned,
        IN `_oob_hook` tinyint(3) unsigned,
        IN `_oob_prefix` varchar(32),
        IN `_oob_mark` int(10) unsigned,
        IN `_oob_in` varchar(32),
        IN `_oob_out` varchar(32),
        IN `_oob_family` tinyint(3) unsigned,
        IN `_oob_protocol` smallint(5) unsigned,
        
        IN `_ip_saddr` binary(16),
        IN `_ip_daddr` binary(16),
        IN `_ip_protocol` tinyint(3) unsigned,
        IN `_ip_tos` tinyint(3) unsigned,
        IN `_ip_ttl` tinyint(3) unsigned,
        IN `_ip_totlen` smallint(5) unsigned,
        IN `_ip_ihl` tinyint(3) unsigned,
        IN `_ip_csum` smallint(5) unsigned,
        IN `_ip_id` smallint(5) unsigned,
        IN `_ip_fragoff` smallint(5) unsigned,

        IN `_ip6_payloadlen` smallint unsigned,
        IN `_ip6_priority` tinyint(3) unsigned,
        IN `_ip6_hoplimit` tinyint(3) unsigned,
        IN `_ip6_flowlabel` int(10),
        IN `_ip6_fragoff` smallint(5),
        IN `_ip6_fragid` int(10) unsigned,

        IN `tcp_sport` smallint(5) unsigned,
        IN `tcp_dport` smallint(5) unsigned,
        IN `tcp_seq` int(10) unsigned,
        IN `tcp_ackseq` int(10) unsigned,
        IN `tcp_window` smallint(5) unsigned,
        IN `tcp_urg` tinyint(1),
        IN `tcp_urgp` smallint(5) unsigned,
        IN `tcp_ack` tinyint(1),
        IN `tcp_psh` tinyint(1),
        IN `tcp_rst` tinyint(1),
        IN `tcp_syn` tinyint(1),
        IN `tcp_fin` tinyint(1),

        IN `udp_sport` smallint(5) unsigned,
        IN `udp_dport` smallint(5) unsigned,
        IN `udp_len` smallint(5) unsigned,

        IN `icmp_type` tinyint(3) unsigned,
        IN `icmp_code` tinyint(3) unsigned,
        IN `icmp_echoid` smallint(5) unsigned,
        IN `icmp_echoseq` smallint(5) unsigned,
        IN `icmp_gateway` int(10) unsigned,
        IN `icmp_fragmtu` smallint(5) unsigned,

        IN `icmpv6_type` tinyint(3) unsigned,
        IN `icmpv6_code` tinyint(3) unsigned,
        IN `icmpv6_echoid` smallint(5) unsigned,
        IN `icmpv6_echoseq` smallint(5) unsigned,
        IN `icmpv6_csum` int(10) unsigned,

        IN `sctp_sport` smallint(5) unsigned,
        IN `sctp_dport` smallint(5) unsigned,
        IN `sctp_csum` int(10) unsigned,

        IN `raw_label` tinyint(3) unsigned,
        IN `raw_type` int(10) unsigned,
        IN `mac_saddr_str` varchar(20),
        IN `mac_daddr_str` varchar(20)
        
        #raw_header varchar(256),
        )
BEGIN
    # local scoped variables
    DECLARE PACKET_ID BIGINT unsigned DEFAULT NULL;

    # insert meta packet (after related items to ensure integrity)
    SET PACKET_ID = INSERT_IP_PACKET(
        # get remote
        INSERT_OR_SELECT_REMOTE(),

        # insert/get MAC transport relation
        INSERT_OR_SELECT_MAC(mac_saddr_str, mac_daddr_str, _oob_protocol, raw_type),

        # get nflog prefix
        INSERT_OR_SELECT_PREFIX(_oob_prefix),

        # get interfaces
        INSERT_OR_SELECT_INTERFACE(_oob_in),
        INSERT_OR_SELECT_INTERFACE(_oob_out),

        # paket payload
        _oob_time_sec, _oob_time_usec, _oob_hook, _oob_mark, _oob_family, 

        _ip_saddr, _ip_daddr, _ip_protocol, _ip_tos, _ip_ttl, _ip_totlen, _ip_ihl, _ip_csum, _ip_id, _ip_fragoff, 

        _ip6_payloadlen, _ip6_priority, _ip6_hoplimit, _ip6_flowlabel, _ip6_fragoff, _ip6_fragid, 

        raw_label
    );

    # low level Packet ?
    IF raw_type != 1 THEN
        CALL PACKET_ADD_HARDWARE_HEADER(PACKET_ID, raw_type, NULL);#raw_header);
    END IF;

    # protocol dispatching/data linking
    # 6::TCP
    IF _ip_protocol = 6 THEN
        CALL PACKET_ADD_TCP(PACKET_ID, tcp_sport, tcp_dport, tcp_seq, tcp_ackseq, tcp_window, tcp_urg, tcp_ack, tcp_psh, tcp_rst, tcp_syn, tcp_fin);

    # 17::UDP
    ELSEIF _ip_protocol = 17 THEN
        CALL PACKET_ADD_UDP(PACKET_ID, udp_sport, udp_dport, udp_len);

    # 132::SCTP
    ELSEIF _ip_protocol = 132 THEN
        CALL PACKET_ADD_SCTP(PACKET_ID, sctp_sport, sctp_dport, sctp_csum);

    # 1::ICMP
    ELSEIF _ip_protocol = 1 THEN
        CALL PACKET_ADD_ICMP(PACKET_ID, icmp_type, icmp_code, icmp_echoid, icmp_echoseq, icmp_gateway, icmp_fragmtu);

    # 58::ICMPv6
    ELSEIF _ip_protocol = 58 THEN
        CALL PACKET_ADD_ICMPV6(PACKET_ID, icmpv6_type, icmpv6_code, icmpv6_echoid, icmpv6_echoseq, icmpv6_csum);

    END IF;
END
$$
delimiter ;

# utility
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

# IP Protocols
# -----------------------------------------------------------------------
# Source: https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml
DROP TABLE IF EXISTS `ip_protocols`;
CREATE TABLE `ip_protocols` (
  `ip_protocol` tinyint(3) unsigned NOT NULL,
  `ip_protocol_name` varchar(18) DEFAULT NULL,
  `ip_protocol_description` varchar(72) DEFAULT NULL,

  PRIMARY KEY `ip_protocol` (`ip_protocol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `ip_protocols` (`ip_protocol`, `ip_protocol_name`, `ip_protocol_description`) 
    VALUES
        (0, 'HOPOPT', 'IPv6 Hop-by-Hop Option'),
        (1, 'ICMP', 'Internet Control Message'),
        (2, 'IGMP', 'Internet Group Management'),
        (3, 'GGP', 'Gateway-to-Gateway'),
        (4, 'IPv4', 'IPv4 encapsulation'),
        (5, 'ST', 'Stream'),
        (6, 'TCP', 'Transmission Control'),
        (7, 'CBT', 'CBT'),
        (8, 'EGP', 'Exterior Gateway Protocol'),
        (9, 'IGP', 'any private interior gateway (used by Cisco for their IGRP)'),
        (10, 'BBN-RCC-MON', 'BBN RCC Monitoring'),
        (11, 'NVP-II', 'Network Voice Protocol'),
        (12, 'PUP', 'PUP'),
        (13, 'ARGUS (deprecated)', 'ARGUS'),
        (14, 'EMCON', 'EMCON'),
        (15, 'XNET', 'Cross Net Debugger'),
        (16, 'CHAOS', 'Chaos'),
        (17, 'UDP', 'User Datagram'),
        (18, 'MUX', 'Multiplexing'),
        (19, 'DCN-MEAS', 'DCN Measurement Subsystems'),
        (20, 'HMP', 'Host Monitoring'),
        (21, 'PRM', 'Packet Radio Measurement'),
        (22, 'XNS-IDP', 'XEROX NS IDP'),
        (23, 'TRUNK-1', 'Trunk-1'),
        (24, 'TRUNK-2', 'Trunk-2'),
        (25, 'LEAF-1', 'Leaf-1'),
        (26, 'LEAF-2', 'Leaf-2'),
        (27, 'RDP', 'Reliable Data Protocol'),
        (28, 'IRTP', 'Internet Reliable Transaction'),
        (29, 'ISO-TP4', 'ISO Transport Protocol Class 4'),
        (30, 'NETBLT', 'Bulk Data Transfer Protocol'),
        (31, 'MFE-NSP', 'MFE Network Services Protocol'),
        (32, 'MERIT-INP', 'MERIT Internodal Protocol'),
        (33, 'DCCP', 'Datagram Congestion Control Protocol'),
        (34, '3PC', 'Third Party Connect Protocol'),
        (35, 'IDPR', 'Inter-Domain Policy Routing Protocol'),
        (36, 'XTP', 'XTP'),
        (37, 'DDP', 'Datagram Delivery Protocol'),
        (38, 'IDPR-CMTP', 'IDPR Control Message Transport Proto'),
        (39, 'TP++', 'TP++ Transport Protocol'),
        (40, 'IL', 'IL Transport Protocol'),
        (41, 'IPv6', 'IPv6 encapsulation'),
        (42, 'SDRP', 'Source Demand Routing Protocol'),
        (43, 'IPv6-Route', 'Routing Header for IPv6'),
        (44, 'IPv6-Frag', 'Fragment Header for IPv6'),
        (45, 'IDRP', 'Inter-Domain Routing Protocol'),
        (46, 'RSVP', 'Reservation Protocol'),
        (47, 'GRE', 'Generic Routing Encapsulation'),
        (48, 'DSR', 'Dynamic Source Routing Protocol'),
        (49, 'BNA', 'BNA'),
        (50, 'ESP', 'Encap Security Payload'),
        (51, 'AH', 'Authentication Header'),
        (52, 'I-NLSP', 'Integrated Net Layer Security TUBA'),
        (53, 'SWIPE (deprecated)', 'IP with Encryption'),
        (54, 'NARP', 'NBMA Address Resolution Protocol'),
        (55, 'MOBILE', 'IP Mobility'),
        (56, 'TLSP', 'Transport Layer Security Protocol (using Kryptonet key management)'),
        (57, 'SKIP', 'SKIP'),
        (58, 'IPv6-ICMP', 'ICMP for IPv6'),
        (59, 'IPv6-NoNxt', 'No Next Header for IPv6'),
        (60, 'IPv6-Opts', 'Destination Options for IPv6'),
        (61, '61', 'any host internal protocol'),
        (62, 'CFTP', 'CFTP'),
        (63, '63', 'any local network'),
        (64, 'SAT-EXPAK', 'SATNET and Backroom EXPAK'),
        (65, 'KRYPTOLAN', 'Kryptolan'),
        (66, 'RVD', 'MIT Remote Virtual Disk Protocol'),
        (67, 'IPPC', 'Internet Pluribus Packet Core'),
        (68, '68', 'any distributed file system'),
        (69, 'SAT-MON', 'SATNET Monitoring'),
        (70, 'VISA', 'VISA Protocol'),
        (71, 'IPCV', 'Internet Packet Core Utility'),
        (72, 'CPNX', 'Computer Protocol Network Executive'),
        (73, 'CPHB', 'Computer Protocol Heart Beat'),
        (74, 'WSN', 'Wang Span Network'),
        (75, 'PVP', 'Packet Video Protocol'),
        (76, 'BR-SAT-MON', 'Backroom SATNET Monitoring'),
        (77, 'SUN-ND', 'SUN ND PROTOCOL-Temporary'),
        (78, 'WB-MON', 'WIDEBAND Monitoring'),
        (79, 'WB-EXPAK', 'WIDEBAND EXPAK'),
        (80, 'ISO-IP', 'ISO Internet Protocol'),
        (81, 'VMTP', 'VMTP'),
        (82, 'SECURE-VMTP', 'SECURE-VMTP'),
        (83, 'VINES', 'VINES'),
        (84, 'TTP/IPTM', 'Transaction Transport Protocol/Internet Protocol Traffic Manager'),
        (85, 'NSFNET-IGP', 'NSFNET-IGP'),
        (86, 'DGP', 'Dissimilar Gateway Protocol'),
        (87, 'TCF', 'TCF'),
        (88, 'EIGRP', 'EIGRP'),
        (89, 'OSPFIGP', 'OSPFIGP'),
        (90, 'Sprite-RPC', 'Sprite RPC Protocol'),
        (91, 'LARP', 'Locus Address Resolution Protocol'),
        (92, 'MTP', 'Multicast Transport Protocol'),
        (93, 'AX.25', 'AX.25 Frames'),
        (94, 'IPIP', 'IP-within-IP Encapsulation Protocol'),
        (95, 'MICP (deprecated)', 'Mobile Internetworking Control Pro.'),
        (96, 'SCC-SP', 'Semaphore Communications Sec. Pro.'),
        (97, 'ETHERIP', 'Ethernet-within-IP Encapsulation'),
        (98, 'ENCAP', 'Encapsulation Header'),
        (99, '99', 'any private encryption scheme'),
        (100, 'GMTP', 'GMTP'),
        (101, 'IFMP', 'Ipsilon Flow Management Protocol'),
        (102, 'PNNI', 'PNNI over IP'),
        (103, 'PIM', 'Protocol Independent Multicast'),
        (104, 'ARIS', 'ARIS'),
        (105, 'SCPS', 'SCPS'),
        (106, 'QNX', 'QNX'),
        (107, 'A/N', 'Active Networks'),
        (108, 'IPComp', 'IP Payload Compression Protocol'),
        (109, 'SNP', 'Sitara Networks Protocol'),
        (110, 'Compaq-Peer', 'Compaq Peer Protocol'),
        (111, 'IPX-in-IP', 'IPX in IP'),
        (112, 'VRRP', 'Virtual Router Redundancy Protocol'),
        (113, 'PGM', 'PGM Reliable Transport Protocol'),
        (114, '114', 'any 0-hop protocol'),
        (115, 'L2TP', 'Layer Two Tunneling Protocol'),
        (116, 'DDX', 'D-II Data Exchange (DDX)'),
        (117, 'IATP', 'Interactive Agent Transfer Protocol'),
        (118, 'STP', 'Schedule Transfer Protocol'),
        (119, 'SRP', 'SpectraLink Radio Protocol'),
        (120, 'UTI', 'UTI'),
        (121, 'SMP', 'Simple Message Protocol'),
        (122, 'SM (deprecated)', 'Simple Multicast Protocol'),
        (123, 'PTP', 'Performance Transparency Protocol'),
        (124, 'ISIS over IPv4', NULL),
        (125, 'FIRE', NULL),
        (126, 'CRTP', 'Combat Radio Transport Protocol'),
        (127, 'CRUDP', 'Combat Radio User Datagram'),
        (128, 'SSCOPMCE', NULL),
        (129, 'IPLT', NULL),
        (130, 'SPS', 'Secure Packet Shield'),
        (131, 'PIPE', 'Private IP Encapsulation within IP'),
        (132, 'SCTP', 'Stream Control Transmission Protocol'),
        (133, 'FC', 'Fibre Channel'),
        (134, 'RSVP-E2E-IGNORE', NULL),
        (135, 'Mobility Header', NULL),
        (136, 'UDPLite', NULL),
        (137, 'MPLS-in-IP', NULL),
        (138, 'manet', 'MANET Protocols'),
        (139, 'HIP', 'Host Identity Protocol'),
        (140, 'Shim6', 'Shim6 Protocol'),
        (141, 'WESP', 'Wrapped Encapsulating Security Payload'),
        (142, 'ROHC', 'Robust Header Compression'),
        (255, 'Reserved', NULL);


# ICMPv4 Types
# -----------------------------------------------------------------------
DROP TABLE IF EXISTS `icmp_types`;
CREATE TABLE `icmp_types` (
  `icmp_type` int(3) NOT NULL,
  `icmp_type_name` varchar(18) DEFAULT NULL,

  PRIMARY KEY `icmp_type` (`icmp_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `icmp_types` (`icmp_type`, `icmp_type_name`) 
    VALUES
        (0,'Echo Reply'),
        (1,'Unassigned'),
        (2,'Unassigned'),
        (3,'Destination Unreachable'),
        (4,'Source Quench'),
        (5,'Redirect'),
        (6,'Alternate Host Address'),
        (7,'Unassigned'),
        (8,'Echo'),
        (9,'Router Advertisement'),
        (10,'Router Selection'),
        (11,'Time Exceeded'),
        (12,'Parameter Problem'),
        (13,'Timestamp'),
        (14,'Timestamp Reply'),
        (15,'Information Request'),
        (16,'Information Reply'),
        (17,'Address Mask Request'),
        (18,'Address Mask Reply'),
        (19,'Reserved (for Security)'),
        (20,'Reserved (for Robustness Experiment)'),
        (30,'Traceroute'),
        (31,'Datagram Conversion Error'),
        (32,'Mobile Host Redirect'),
        (33,'IPv6 Where-Are-You'),
        (34,'IPv6 I-Am-Here'),
        (35,'Mobile Registration Request'),
        (36,'Mobile Registration Reply'),
        (37,'Domain Name Request'),
        (38,'Domain Name Reply'),
        (39,'SKIP'),
        (40,'Photuris');

# Simple Log View
# -----------------------------------------------------------------------
DROP VIEW IF EXISTS `log`;
CREATE VIEW `log` AS
    SELECT 
        # meta packet
        `packets`.`_packet_id`, `packets`.`_remote_id`, `packets`.`timestamp`, `packets`.`oob_time_sec`,
        
        # remote host
        SUBSTRING_INDEX(`remotes`.`user`, '@', -1) as `host`,

        # rule
        `prefix_types`.`prefix`,

        # interfaces
        `t_if_in`.`interface_name` as `if_in`, `t_if_out`.`interface_name` as `if_out`,

        # ip related
        `packets`.`ip_daddr`, `packets`.`ip_saddr`, `packets`.`ip_protocol`,

        # plain text protocols/types
        `ip_protocols`.`ip_protocol_name`, `ip_protocols`.`ip_protocol_description`,

        # remote host, mac
        `mac`.`mac_src`, `mac`.`mac_dst`,
        
        # ports
        JOIN_PORTS(`tcp`.`tcp_sport`, `udp`.`udp_sport`, `sctp`.`sctp_sport`) as `sport`,
        JOIN_PORTS(`tcp`.`tcp_dport`, `udp`.`udp_dport`, `sctp`.`sctp_dport`) as `dport`,

        # protocol related
        `udp`.`udp_len`,
        `icmp`.`icmp_type`, `icmp_types`.`icmp_type_name`, `icmp`.`icmp_code`, `icmp`.`icmp_gateway`,
        `sctp`.`sctp_csum`
    
    FROM `packets`
        
        LEFT JOIN `mac` USING(`_mac_id`)
        LEFT JOIN `remotes` USING(`_remote_id`)
        LEFT JOIN `prefix_types` USING(`_prefix_id`)
        LEFT JOIN `interfaces` `t_if_in` ON `packets`.`_if_in_id` = `t_if_in`.`_interface_id`
        LEFT JOIN `interfaces` `t_if_out` ON `packets`.`_if_out_id` = `t_if_out`.`_interface_id`
        LEFT JOIN `udp` USING(`_packet_id`)
        LEFT JOIN `tcp` USING(`_packet_id`)
        LEFT JOIN `sctp` USING(`_packet_id`)
        LEFT JOIN `icmp` USING(`_packet_id`)
        
        LEFT JOIN `icmp_types` USING(`icmp_type`)
        LEFT JOIN `ip_protocols` USING(`ip_protocol`)
        
    ORDER BY `_packet_id` DESC;


# CREATE/UPDATE STRUCTURE FINISHED
SET foreign_key_checks = 1;