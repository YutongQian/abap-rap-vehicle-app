# abap-rap-vehicle-app
# 🧩 ABAP RAP Case Studies

A collection of case studies (Fallstudien) I completed while learning the
**ABAP RESTful Application Programming Model (RAP)** and modern ABAP development.

---

## 🛠️ Tech Stack

- ABAP RESTful Application Programming Model (RAP), managed implementation with draft
- ABAP Dictionary: tables, domains with fixed values, data elements, extension includes
- Core Data Services (CDS): data model, projection views, value help views, extend views
- Behavior Definitions, Behavior Pools, Behavior Extensions
- Entity Manipulation Language (EML)
- OData V4, SAP Fiori Elements, Metadata Extensions (UI annotations)
- CDS Access Control (DCL) and authorization concept
- ABAP Development Tools (Eclipse), abapGit
## 📂 Main Case StudiesM Overview

| # | Case Study | Package | Key Concepts |
|---|---|---|---|
| 1 | Flight Maintenance | `Z10_PROJ2_RAP` | Field control, determination, validation, value help, authorization |
| 2 | Vehicle Type Management | `ZCASE_10_B1` | DDIC design, validations with range tables, custom value helps, EML program |
| 3 | Extensibility of the Vehicle Type BO | `ZCASE_10_B1` | Extension include, extend views, behavior extensions, fixed value append |
## ✈️ Case Study  – Flight Maintenance (RAP Business Object)

A RAP business object for flights, generated from a database table and extended with custom business logic.

**Features**
- **Dynamic field control:** carrier ID, connection ID and flight date are *mandatory on create*
  and *read-only on update*
- **Determination on save** (`set_changecount`): counts successful changes per record.
  The implementation avoids endless determination loops and also works for mass changes
- **Validation** (`check_flightdate`): rejects invalid dates. It runs only on create, so it
  is not executed unnecessarily
- Validation and determination are assigned to the **draft determine action `Prepare`**
- Message class for user-facing error messages
- **Value help** for carrier IDs
- **Metadata extension:** custom labels, admin fields hidden, custom field order on the object page
- **Authorization concept (design):** users see and maintain only flights of carriers they are
  authorized for (CDS access control + authorization checks in the behavior implementation)

---

## 🚗 Case Study  – Vehicle Type Management

A maintenance solution for vehicle types (cars, trucks, buses) with two entry channels:
a **Fiori Elements app** for manual maintenance and an **EML-based program** that imports data
from a (simulated) internet service.

**Data model (ABAP Dictionary)**
- Database table with semantic key (manufacturer + model), typed with data elements and domains
- Domain with **fixed values** for the vehicle kind (CAR, TRUCK, BUS)
- Quantity fields linked to units of measure
- **Extension include** with a required field suffix (`ZCA`), so customers can extend the table

**Business logic**
- All checks in **one validation method**: value ranges, kind-specific rules
  (e.g. tank capacity for cars, cargo only for trucks, passengers only for buses) and valid units
- **Range tables** for the checks
- Vehicle kinds are **not hard-coded**: kinds added later via fixed value appends are recognized as valid
- Dedicated message class for error texts

**UI (Fiori Elements)**
- Value help for vehicle kind, based on a custom CDS view on the domain's fixed values
- **Filtered value helps** that offer only mass units for cargo and only volume units for tank capacity
- Metadata extension: field layout, admin fields only in the filter bar, extension fields hidden

**EML program** (`ZCL_##_BUS1VTYPESMAINT`)
- Console application (`if_oo_adt_classrun`), no user interaction needed
- Reads existing records and decides between **create** and **update**
- Uses `MODIFY ENTITIES`, `COMMIT ENTITIES` and `ROLLBACK ENTITIES` correctly
- Evaluates `FAILED` and `REPORTED` and prints the result for each record
- *Optional extension:* prints detailed error messages per record, including multiple errors
- Concept for **preventing delete** in the program while the Fiori app still allows it

---

## 🧱 Case Study  – Extensibility (Developer vs. Customer Role)

The vehicle type BO is extended with new vehicle kinds, without changing the original objects.
This follows SAP's extensibility concept.

**As the "SAP developer":** I prepared the extension points
- Extensible database table (extension include, field suffix)
- Extensible CDS views (metadata and element extensions, restricted to the main data source)
- Extensible behavior definition: validations and determinations on save, extensible draft
  `Prepare` action, extensible mapping

**As the "customer developer":** I used the extension points
- Append structure on the extension include for the new fields
- Fixed value append for new vehicle kinds
- **Extend views** for the CDS views
- **Behavior extension** with new fields and validations (load capacity, height, reach)
- Customer message class
- Custom value help for length units
- Metadata extension for the new UI fields
- Adapted EML maintenance program

---


## 📸 Screenshots

| Flight App – Object Page | Vehicle Types – List |
|---|---|
| ![](screenshots/flight_object_page.jpg) | ![](screenshots/vehicletype_list.jpg) |

| Value Help Vehicle Kind | EML Console Output |
|---|---|
| ![](screenshots/vehiclekind_vh.jpg) | ![](screenshots/eml_console.jpg) |


---

## 🚀 How to Use

1. Install [abapGit](https://abapgit.org) in your ABAP system
2. Create an online repository with this URL and pull the objects
3. Activate all objects
4. Run the data generator class to fill the vehicle type table with sample data
5. Publish the service bindings and open the Fiori Elements preview

---
## 📚 What I Learned

- Designing database tables that are suitable for RAP and extensible by customers
- Implementing business logic in the RAP lifecycle: determinations, validations and draft handling
- Avoiding pitfalls such as endless determination loops
- Writing EML programs with correct transaction handling (`COMMIT` / `ROLLBACK ENTITIES`)
- Building UIs with annotations only, including filtered value helps
- Understanding SAP's extensibility model: what the provider must enable and what the customer may extend

## 👤 Author

Yutong Qian
