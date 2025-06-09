# Neovim Configuration Testing Plan

## Executive Summary

This document outlines a comprehensive testing strategy for a Neovim configuration using Lua and lazy.nvim. The plan enables headless, automated testing to validate configuration changes without manual intervention.

## Testing Framework Evaluation

### 1. **plenary.nvim** (Recommended)
- **Pros:**
  - Most widely adopted in Neovim ecosystem
  - Built-in test harness with headless support
  - Excellent async support
  - Used by telescope.nvim, null-ls, and other major plugins
  - Minimal setup required
- **Cons:**
  - Requires adding as a plugin dependency
  - Less documentation than traditional Lua testing frameworks

### 2. **busted**
- **Pros:**
  - Mature Lua testing framework
  - Rich assertion library
  - Good documentation
- **Cons:**
  - Requires external installation
  - More complex Neovim API mocking
  - Not specifically designed for Neovim

### 3. **mini.test**
- **Pros:**
  - Lightweight and minimal
  - Part of mini.nvim ecosystem
  - Good for simple tests
- **Cons:**
  - Less feature-rich
  - Smaller community

**Decision:** Use **plenary.nvim** as the primary testing framework due to its Neovim-specific features and community adoption.

## Test Structure

```
nvim/
├── tests/
│   ├── init.lua                    # Test runner configuration
│   ├── minimal_init.lua            # Minimal Neovim config for tests
│   ├── fixtures/                   # Test fixtures
│   │   ├── sample.lua
│   │   └── .env.test
│   ├── unit/                       # Unit tests
│   │   ├── util/
│   │   │   ├── folding_spec.lua
│   │   │   ├── printing_spec.lua
│   │   │   └── remap_spec.lua
│   │   └── core/
│   │       └── options_spec.lua
│   ├── integration/                # Integration tests
│   │   ├── plugin_loading_spec.lua
│   │   ├── lsp_config_spec.lua
│   │   └── keymaps_spec.lua
│   └── e2e/                       # End-to-end tests
│       └── startup_spec.lua
```

## Test Categories

### 1. Unit Tests

#### Utility Functions
```lua
-- tests/unit/util/folding_spec.lua
describe("folding utilities", function()
  it("generates correct foldtext for function", function()
    -- Test foldtext generation
  end)
  
  it("caches treesitter parser correctly", function()
    -- Test parser caching logic
  end)
end)
```

#### Core Options
```lua
-- tests/unit/core/options_spec.lua
describe("vim options", function()
  it("sets colorcolumn correctly", function()
    -- Test dynamic colorcolumn generation
  end)
  
  it("configures folding based on Neovim version", function()
    -- Test version-specific folding setup
  end)
end)
```

### 2. Integration Tests

#### Plugin Loading
```lua
-- tests/integration/plugin_loading_spec.lua
describe("plugin loading", function()
  it("loads all plugins successfully", function()
    -- Test lazy.nvim plugin loading
  end)
  
  it("respects lazy loading events", function()
    -- Test event-based loading
  end)
end)
```

#### LSP Configuration
```lua
-- tests/integration/lsp_config_spec.lua
describe("LSP configuration", function()
  it("configures language servers correctly", function()
    -- Test server configurations
  end)
  
  it("sets up keybindings on attach", function()
    -- Test buffer-local keymaps
  end)
end)
```

### 3. End-to-End Tests

```lua
-- tests/e2e/startup_spec.lua
describe("Neovim startup", function()
  it("starts without errors", function()
    -- Test clean startup
  end)
  
  it("loads configuration in correct order", function()
    -- Test bootstrap sequence
  end)
end)
```

## Implementation Plan

### Phase 1: Test Infrastructure Setup

1. **Add plenary.nvim as test dependency**
   ```lua
   -- lua/digia/plugin/init.lua (or separate test config)
   {
     "nvim-lua/plenary.nvim",
     lazy = false,
     priority = 1000,
   }
   ```

2. **Create minimal test configuration**
   ```lua
   -- tests/minimal_init.lua
   vim.opt.runtimepath:append(vim.fn.stdpath("config"))
   vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/plenary.nvim")
   ```

3. **Create test runner script**
   ```bash
   #!/usr/bin/env bash
   # scripts/test.sh
   nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal_init.lua'}"
   ```

### Phase 2: Core Utility Tests

Focus on testing pure functions first:
- `folding.lua` utilities
- `printing.lua` recursive print
- `remap.lua` keymap functions

### Phase 3: Configuration Tests

Test configuration loading and options:
- Options setting verification
- Autocommand registration
- Plugin spec loading

### Phase 4: Integration Tests

Test plugin interactions:
- LSP server setup
- Completion configuration
- Keybinding conflicts

### Phase 5: CI/CD Integration

1. **GitHub Actions workflow**
   ```yaml
   name: Tests
   on: [push, pull_request]
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - name: Install Neovim
           uses: rhysd/action-setup-nvim@v1
           with:
             neovim: true
             version: stable
         - name: Run tests
           run: make test
   ```

2. **Makefile for test commands**
   ```makefile
   test:
   	./scripts/test.sh
   
   test-unit:
   	./scripts/test.sh tests/unit
   
   test-integration:
   	./scripts/test.sh tests/integration
   ```

## Specific Test Cases

### Critical Path Tests

1. **Configuration Bootstrap**
   - Verify lazy.nvim installation
   - Test plugin loading order
   - Validate error handling

2. **Environment Variable Loading**
   ```lua
   it("loads .env file correctly", function()
     -- Test with fixture .env file
     -- Verify environment variables are set
     -- Test missing file handling
   end)
   ```

3. **LSP Keybinding Setup**
   ```lua
   it("sets buffer-local keymaps on LSP attach", function()
     -- Mock LSP client attachment
     -- Verify keymaps are set
     -- Test keymap functionality
   end)
   ```

4. **Folding Performance**
   ```lua
   it("handles large files efficiently", function()
     -- Create large test file
     -- Measure folding performance
     -- Verify caching works
   end)
   ```

### Edge Case Tests

1. **Missing Dependencies**
   - Test behavior when plugins fail to load
   - Verify graceful degradation

2. **Version Compatibility**
   - Mock different Neovim versions
   - Test conditional features

3. **File System Operations**
   - Test parent directory creation
   - Verify whitespace trimming safety

## Running Tests

### Local Development
```bash
# Run all tests
make test

# Run specific test file
nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedFile tests/unit/util/folding_spec.lua"

# Run with coverage (requires additional setup)
make test-coverage
```

### Continuous Integration
Tests run automatically on:
- Push to any branch
- Pull request creation/update
- Scheduled weekly runs

## Success Metrics

1. **Coverage Goals**
   - 80% coverage for utility functions
   - 60% coverage for configuration code
   - 100% coverage for critical paths

2. **Performance Targets**
   - Unit tests complete in < 1 second
   - Integration tests complete in < 5 seconds
   - Full test suite completes in < 30 seconds

3. **Reliability**
   - Zero flaky tests
   - Consistent results across environments
   - Clear error messages on failures

## Maintenance

1. **Test Review**
   - Review test effectiveness monthly
   - Update tests with configuration changes
   - Remove obsolete tests

2. **Documentation**
   - Keep test examples in CLAUDE.md
   - Document test patterns
   - Maintain troubleshooting guide

## Next Steps

1. Get approval for testing approach
2. Set up basic test infrastructure
3. Write initial unit tests for utilities
4. Expand to integration tests
5. Add CI/CD pipeline
6. Document testing practices

This plan provides a foundation for comprehensive, automated testing of the Neovim configuration while maintaining development velocity and code quality.