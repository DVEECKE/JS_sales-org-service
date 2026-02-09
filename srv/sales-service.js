const cds = require('@sap/cds');

/**
 * SalesService implementation with custom handlers
 *
 * BEGINNER NOTE:
 * - This class extends cds.ApplicationService to add custom logic
 * - CAP automatically connects this file to sales-service.cds (matching filename)
 * - The init() method is where we register our custom handlers
 */
module.exports = class SalesService extends cds.ApplicationService {

  /**
   * Initialize the service and register event handlers
   *
   * BEGINNER NOTE:
   * - 'async init()' runs when the service starts
   * - this.entities gives us access to the entities defined in the CDS service
   * - We register handlers for actions and lifecycle events (before/after CREATE/READ/etc.)
   */
  async init() {

    // Get reference to SalesRules entity for querying
    const { SalesRules } = this.entities;

    /**
     * Handler for 'lookup' action
     *
     * BEGINNER NOTE:
     * - this.on('lookup', ...) registers a handler for the lookup action
     * - This handler responds to POST /odata/v4/sales/lookup
     * - req.data contains the input data
     * - return value becomes the HTTP response
     *
     * Business Logic:
     * 1. Extract country and region from request
     * 2. Validate that country is provided
     * 3. Query SalesRules for exact match (country AND region)
     * 4. Return result or error
     */
    this.on('lookup', async (req) => {
      // Extract input parameters
      const { country, region } = req.data.request;

      // Validate input: country is required
      if (!country) {
        return req.error(400, 'Country code is required');
      }

      // Query for exact match
      // BEGINNER NOTE:
      // - SELECT.one.from() returns a single record or undefined
      // - .where() filters by exact match on both country AND region
      // - region || null ensures we match null if region is undefined/null
      const rule = await SELECT.one.from(SalesRules)
        .where({
          country: country,
          region: region || null
        });

      // Handle not found case
      if (!rule) {
        return req.error(404, `No sales rule found for country="${country}", region="${region || 'null'}"`);
      }

      // Return successful result
      // BEGINNER NOTE:
      // - Return object must match LookupResponse type from sales-service.cds
      return {
        salesOrg: rule.salesOrg,
        salesRepEmail: rule.salesRepEmail
      };
    });

    /**
     * Before-handler for CREATE and UPDATE operations
     *
     * BEGINNER NOTE:
     * - this.before() runs BEFORE the operation is executed
     * - Useful for validation, data transformation, authorization
     * - Here we normalize country codes to uppercase
     */
    this.before(['CREATE', 'UPDATE'], 'SalesRules', (req) => {
      // Normalize country code to uppercase
      // Example: 'fr' → 'FR', 'de' → 'DE'
      if (req.data.country) {
        req.data.country = req.data.country.toUpperCase();
      }
    });

    /**
     * Optional: After-handler for logging (for learning purposes)
     *
     * BEGINNER NOTE:
     * - this.after() runs AFTER the operation is executed
     * - Useful for logging, notifications, derived calculations
     * - Commented out by default to avoid log noise
     */
    /*
    this.after('CREATE', 'SalesRules', (result, req) => {
      console.log(`[SalesService] Created new rule: ${result.country}/${result.region} → ${result.salesOrg}`);
    });
    */

    // Call parent init to ensure proper service initialization
    // BEGINNER NOTE: Always call super.init() at the end
    return super.init();
  }
};
