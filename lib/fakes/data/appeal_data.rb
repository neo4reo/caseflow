module Fakes::Data::AppealData
  # rubocop:disable Metrics/MethodLength
  def self.default_vacols_ids
    default_records.map(&:vacols_id)
  end

  def self.default_records
    [
      Generators::Appeal.build(
        type: "Court Remand",
        vacols_id: "111111",
        date_assigned: "2013-05-17 00:00:00 UTC".to_datetime,
        date_received: "2013-05-31 00:00:00 UTC".to_datetime,
        date_due: "2018-02-13 00:00:00 UTC".to_datetime,
        signed_date: nil,
        vbms_id: "1234",
        veteran_first_name: "Simple",
        veteran_middle_initial: "A",
        veteran_last_name: "Case",
        docket_number: "13 11-265",
        docket_date: "2014-03-25 00:00:00 UTC".to_datetime,
        regional_office_key: "RO13",
        issues: [
          { disposition: :remanded,
            vacols_sequence_id: 1,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 2,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 3,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] }
        ]
      ),
      Generators::Appeal.build(
        type: "Remand",
        vacols_id: "222222",
        date_assigned: "2013-05-17 00:00:00 UTC".to_datetime,
        date_received: nil,
        date_due: "2018-02-14 00:00:00 UTC".to_datetime,
        signed_date: nil,
        vbms_id: "5",
        veteran_first_name: "Large",
        veteran_middle_initial: "B",
        veteran_last_name: "Case",
        docket_number: "13 11-265",
        docket_date: "2014-03-26 00:00:00 UTC".to_datetime,
        regional_office_key: "RO13",
        issues: [
          { disposition: :remanded,
            vacols_sequence_id: 1,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 2,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 3,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] }
        ]
      ),
      Generators::Appeal.build(
        type: "Remand",
        vacols_id: "333333",
        date_assigned: "2013-04-23 00:00:00 UTC".to_datetime,
        date_received: "2013-04-29 00:00:00 UTC".to_datetime,
        date_due: "2018-02-22 00:00:00 UTC".to_datetime,
        signed_date: nil,
        vbms_id: "6",
        veteran_first_name: "Redacted",
        veteran_middle_initial: "C",
        veteran_last_name: "Case",
        docket_number: "13 11-265",
        docket_date: "2014-03-30 00:00:00 UTC".to_datetime,
        regional_office_key: "RO13",
        issues: [
          { disposition: :remanded,
            vacols_sequence_id: 1,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 2,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 3,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] }
        ]
      )
    ]
  end

  def self.default_queue_records
    [
      Generators::Appeal.build(
        type: "Original",
        vacols_id: "111111",
        date_assigned: "2013-05-17 00:00:00 UTC".to_datetime,
        date_received: "2013-05-31 00:00:00 UTC".to_datetime,
        date_due: "2018-02-13 00:00:00 UTC".to_datetime,
        signed_date: nil,
        vbms_id: "1234",
        veteran_first_name: "Vera",
        veteran_middle_initial: "A",
        veteran_last_name: "Marshall",
        docket_number: "13 11-265",
        docket_date: "2014-03-25 00:00:00 UTC".to_datetime,
        regional_office_key: "RO13",
        issues: [
          {
            vacols_sequence_id: 1,
            codes: %w[02 15 03 7101],
            labels: ["Compensation", "Service connection", "All Others", "Hypertensive vascular disease (hypertension and isolated systolic hypertension)"],
            note: "hypertension secondary to DMII.",
          }
        ]
      ),
      Generators::Appeal.build(
        type: "Post Remand",
        vacols_id: "222222",
        date_assigned: "2013-05-17 00:00:00 UTC".to_datetime,
        date_received: nil,
        date_due: "2018-02-14 00:00:00 UTC".to_datetime,
        signed_date: nil,
        vbms_id: "5",
        veteran_first_name: "Joe",
        veteran_last_name: "Snuffy",
        docket_number: "13 11-265",
        docket_date: "2014-03-26 00:00:00 UTC".to_datetime,
        regional_office_key: "RO13",
        issues: [
          { disposition: :remanded,
            vacols_sequence_id: 1,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 2,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 3,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] }
        ]
      ),
      Generators::Appeal.build(
        type: "Court Remand",
        vacols_id: "333333",
        date_assigned: "2013-04-23 00:00:00 UTC".to_datetime,
        date_received: "2013-04-29 00:00:00 UTC".to_datetime,
        date_due: "2018-02-22 00:00:00 UTC".to_datetime,
        signed_date: nil,
        vbms_id: "6",
        veteran_first_name: "Andrea",
        veteran_middle_initial: "C",
        veteran_last_name: "Rasti",
        docket_number: "13 11-265",
        docket_date: "2014-03-30 00:00:00 UTC".to_datetime,
        regional_office_key: "RO13",
        issues: [
          { disposition: :remanded,
            vacols_sequence_id: 1,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 2,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 3,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] }
        ]
      ),
      Generators::Appeal.build(
        type: "Original",
        vacols_id: "333333",
        date_assigned: "2013-04-23 00:00:00 UTC".to_datetime,
        date_received: "2013-04-29 00:00:00 UTC".to_datetime,
        date_due: "2018-02-22 00:00:00 UTC".to_datetime,
        signed_date: nil,
        vbms_id: "6",
        veteran_first_name: "Daniel",
        veteran_last_name: "Nino",
        docket_number: "13 11-265",
        docket_date: "2014-03-30 00:00:00 UTC".to_datetime,
        regional_office_key: "RO13",
        issues: [
          { disposition: :remanded,
            vacols_sequence_id: 1,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 2,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 3,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] }
        ]
      ),
      Generators::Appeal.build(
        type: "Remand",
        vacols_id: "333333",
        date_assigned: "2013-04-23 00:00:00 UTC".to_datetime,
        date_received: "2013-04-29 00:00:00 UTC".to_datetime,
        date_due: "2018-02-22 00:00:00 UTC".to_datetime,
        signed_date: nil,
        vbms_id: "6",
        veteran_first_name: "Daniel",
        veteran_last_name: "Nino",
        docket_number: "13 11-265",
        docket_date: "2014-03-30 00:00:00 UTC".to_datetime,
        regional_office_key: "RO13",
        issues: [
          { disposition: :remanded,
            vacols_sequence_id: 1,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 2,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 3,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] }
        ]
      ),
      Generators::Appeal.build(
        type: "Remand",
        vacols_id: "333333",
        date_assigned: "2013-04-23 00:00:00 UTC".to_datetime,
        date_received: "2013-04-29 00:00:00 UTC".to_datetime,
        date_due: "2018-02-22 00:00:00 UTC".to_datetime,
        signed_date: nil,
        vbms_id: "6",
        veteran_first_name: "Daniel",
        veteran_last_name: "Nino",
        docket_number: "13 11-265",
        docket_date: "2014-03-30 00:00:00 UTC".to_datetime,
        regional_office_key: "RO13",
        issues: [
          { disposition: :remanded,
            vacols_sequence_id: 1,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 2,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 3,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] }
        ]
      ),
      Generators::Appeal.build(
        type: "Clear and Unmistakable Error",
        vacols_id: "333333",
        date_assigned: "2013-04-23 00:00:00 UTC".to_datetime,
        date_received: "2013-04-29 00:00:00 UTC".to_datetime,
        date_due: "2018-02-22 00:00:00 UTC".to_datetime,
        signed_date: nil,
        vbms_id: "6",
        veteran_first_name: "Daniel",
        veteran_last_name: "Nino",
        docket_number: "13 11-265",
        docket_date: "2014-03-30 00:00:00 UTC".to_datetime,
        regional_office_key: "RO13",
        issues: [
          { disposition: :remanded,
            vacols_sequence_id: 1,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 2,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] },
          { disposition: :remanded,
            vacols_sequence_id: 3,
            codes: %w[02 15 03 5252],
            labels: ["Compensation", "Service connection", "All Others", "Thigh, limitation of flexion of"] }
        ]
      )
    ]
  end
  # rubocop:enable Metrics/MethodLength
end
