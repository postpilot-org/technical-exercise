import { Controller } from "@hotwired/stimulus";
import FlatfileImporter from "flatfile-csv-importer";
import Rails from "@rails/ujs";

FlatfileImporter.setVersion(2);

export default class extends Controller {
  static values = {
    licenseKey: String,
    disableManualInput: Boolean,
    customerEmail: String,
    customerId: String,
    uploadPath: String,
    codeDuplicatesPath: String
  };

  static targets = ["input"];

  connect() {
    this.importer = new FlatfileImporter(
      this.licenseKeyValue,
      this.config,
      this.customerObject
    )

    this.importer.registerFieldHook('code', async rows => {
      return this.validateCodesUniqueness(rows).then((duplicates) => duplicates)
    })
  }

  validateCodesUniqueness = (rows) => {
    const url = this.codeDuplicatesPathValue
    const data = { codes: rows.map(row => row[0]) }

    return new Promise((resolve, _) => {
      Rails.ajax({
        type: 'POST',
        dataType: 'json',
        url: url,
        success: (response) => {
          let duplicates = []

          rows.forEach((row) => {
            if (response.includes(row[0])) {
              duplicates.push([
                {
                  info: [
                    {
                      message: 'Coupon code with this value already exists',
                      level: 'error'
                    }
                  ]
                },
                row[1]
              ]);
            }
          })

          resolve(duplicates)
        },
        beforeSend(xhr, options) {
          xhr.setRequestHeader('Accept', 'application/json; charset=UTF-8')
          xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')

          options.data = JSON.stringify(data)

          return true
        }
      })
    })
  }

  openImporter = () => {
    this.importer.requestDataFromUser().then((results) => {
      let data = { codes: results.validData.map((row) => row["code"]) };

      Rails.ajax({
        type: "POST",
        dataType: "json",
        url: this.uploadPathValue,
        data: new URLSearchParams(data).toString(),
        success: (_data) => this.element.submit(),
        error: (_xhr, _status, msg) => console.log("error", msg),
      })
    });
  };

  get config() {
    return {
      allowCustom: false,
      allowInvalidSubmit: false,
      disableManualInput: true,
      fields: [...this.fields],
      maxRecords: 20000,
      styleOverrides: {
        primaryButtonColor: "#1F82D4",
        successColor: "#1F82D4",
      },
      type: "CouponCode",
    };
  }

  get customerObject() {
    return {
      email: this.customerEmailValue,
      userId: this.customerIdValue,
    };
  }

  get fields() {
    return [
      {
        alternates: ["code", "Discount code", "discount_code", "coupon_code"],
        key: "code",
        label: "Coupon Code",
        validators: [{ validate: "required" }, { validate: "unique" }],
      },
    ];
  }
}
