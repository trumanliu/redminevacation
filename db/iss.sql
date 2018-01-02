ALTER TABLE `redmine3`.`time_entries` 
ADD COLUMN `audit_id` INT(11) NULL AFTER `updated_on`,
ADD COLUMN `audit_name` VARCHAR(45) NULL AFTER `audit_id`,
ADD COLUMN `audit_hours` VARCHAR(45) NULL AFTER `audit_name`,
ADD COLUMN `audit_status` VARCHAR(45) NULL AFTER `audit_hours`,
ADD COLUMN `username` VARCHAR(45) NULL AFTER `audit_status`;
