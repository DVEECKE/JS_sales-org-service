using { cuid, managed } from '@sap/cds/common';

namespace sap.capire.sales;

/**
 * SalesRules entity maps country/region combinations to sales organizations and representatives.
 *
 * BEGINNER NOTE:
 * - 'cuid' aspect provides a UUID primary key (ID field)
 * - 'managed' aspect adds audit fields: createdBy, createdAt, modifiedBy, modifiedAt
 * - These are automatically populated by CAP framework
 *
 * Lookup Logic: Exact match on both country AND region
 * - No fallback or inheritance - each rule must be explicit
 */
entity SalesRules : cuid, managed {

  /**
   * ISO 3166-1 alpha-2 country code (2 uppercase letters)
   * Examples: 'FR' (France), 'DE' (Germany), 'US' (United States)
   *
   * @assert.format - Validates format using regex: exactly 2 uppercase letters [A-Z]
   * @mandatory - Field cannot be null
   */
  country         : String(2) @assert.format: '[A-Z]{2}' @mandatory;

  /**
   * Optional region within the country (free text)
   * Examples: 'Paris', 'Bavaria', 'California'
   *
   * Can be null for country-level rules
   */
  region          : String(100);

  /**
   * Sales organization identifier
   * Examples: 'FR-SALES', 'DE-NORTH', 'US-WEST'
   *
   * @mandatory - Must be specified for every rule
   */
  salesOrg        : String(50) @mandatory;

  /**
   * Sales representative email address
   * Examples: 'john.doe@example.com'
   *
   * @assert.format - Validates email format with regex
   * @mandatory - Must be specified for every rule
   */
  salesRepEmail   : String(100) @assert.format: '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}' @mandatory;
}
