using { sap.capire.sales as sales } from '../db/sales';

/**
 * SalesService provides CRUD operations for managing sales rules
 * and a lookup API for finding sales org/rep based on country/region.
 *
 * BEGINNER NOTE:
 * - 'service' groups related entities and actions into an API
 * - This service will be available at: http://localhost:4004/odata/v4/sales
 */
service SalesService {

  /**
   * SalesRules entity exposed for CRUD operations via OData
   *
   * BEGINNER NOTE:
   * - 'projection on' creates a view of the entity from the db layer
   * - @odata.draft.enabled enables draft mode for the Fiori app
   *   This allows users to create/edit records without immediately saving
   *   They can save as draft, then activate later
   */
  @odata.draft.enabled
  entity SalesRules as projection on sales.SalesRules;

  /**
   * Type definitions for the lookup action
   *
   * BEGINNER NOTE:
   * - 'type' defines the structure of data (like a schema)
   * - These types make the API contract clear and type-safe
   */

  /**
   * Input type for lookup request
   * Contains country (mandatory) and region (optional)
   */
  type LookupRequest {
    country : String(2);
    region  : String(100);
  }

  /**
   * Output type for lookup response
   * Contains sales organization ID and sales rep email
   */
  type LookupResponse {
    salesOrg      : String(50);
    salesRepEmail : String(100);
  }

  /**
   * Lookup action: Find sales org and rep for exact country+region match
   *
   * BEGINNER NOTE:
   * - 'action' defines a custom API endpoint (like a REST endpoint)
   * - Called via POST: /odata/v4/sales/lookup
   * - Input/output types ensure type safety
   * - Implementation is in srv/sales-service.js
   *
   * Usage example with curl:
   * curl -X POST http://localhost:4004/odata/v4/sales/lookup \
   *   -H "Content-Type: application/json" \
   *   -d '{"request": {"country": "FR", "region": "Paris"}}'
   *
   * Expected response:
   * {"salesOrg":"FR-PARIS-SALES","salesRepEmail":"paris.sales@example.com"}
   */
  action lookup(request : LookupRequest) returns LookupResponse;
}
