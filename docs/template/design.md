# Product Requirements Document

## Project Overview

**Project Name:** codebase-tutor
**Type:** AI-Powered Learning Tool
**Purpose:** Help developers understand and learn from complex codebases using AI-powered analysis and guidance

## Product Vision

Create an intelligent codebase tutor that combines PocketFlow's agentic architecture with AI-powered code analysis to help developers understand, navigate, and learn from complex codebases through guided exploration and educational insights.

## User Stories

### As a Developer

1. I want to quickly understand unfamiliar codebases without spending hours reading documentation
2. I want AI-powered guidance to help me navigate complex code structures
3. I want to learn about code patterns and architectural decisions in existing projects
4. I want intelligent explanations of how different components work together

### As an AI Assistant

1. I need to analyze codebase structure and provide meaningful insights
2. I need to identify key architectural patterns and code relationships
3. I need to provide educational explanations about code functionality
4. I need to guide developers through complex code exploration

## Functional Requirements

### Core Framework

1. **Node System**
   - Implement three-phase lifecycle (prep, exec, post)
   - Support both sync and async operations
   - Provide clear error handling patterns
   - Enable state sharing through store

2. **Flow System**
   - Action-based transitions between nodes
   - Support for conditional branching
   - Error recovery paths
   - Flow composition and reusability

3. **Utility Layer**
   - Standardized pattern for external service integration
   - Built-in retry and circuit breaker support
   - Connection pooling and resource management
   - Comprehensive error handling

### Development Tools

1. **Testing Framework**
   - Pytest integration with fixtures
   - Node-level unit testing utilities
   - Flow-level integration testing
   - Mock utilities for external services

2. **Code Quality**
   - Ruff for formatting and linting
   - Pyright for type checking
   - Pre-commit hooks
   - Comprehensive type hints

3. **Documentation**
   - Auto-generated API documentation
   - Example implementations
   - Developer guides
   - Architecture documentation

## Non-Functional Requirements

### Performance

- Nodes should execute in under 100ms for simple operations
- Support for async operations to prevent blocking
- Efficient store management to minimize memory usage
- Lazy loading of utilities

### Reliability

- Graceful error handling at all levels
- Retry mechanisms for transient failures
- Circuit breakers for external services
- Comprehensive logging for debugging

### Maintainability

- Clear separation of concerns
- Consistent coding patterns
- Comprehensive test coverage (>80%)
- Well-documented codebase

### Developer Experience

- Quick setup (<5 minutes)
- Clear examples and templates
- Helpful error messages
- AI-friendly documentation structure

## Acceptance Criteria

### Project Setup

- [ ] Developer can set up new project in under 5 minutes
- [ ] All dependencies install correctly with `uv sync`
- [ ] Basic example runs with `python main.py`
- [ ] Tests pass with `uv run pytest`

### Node Development

- [ ] Developer can create new node following template
- [ ] Node tests can be written easily
- [ ] Error handling works as expected
- [ ] Type hints provide good IDE support

### Flow Development

- [ ] Developer can compose nodes into flows
- [ ] Transitions work correctly based on actions
- [ ] Error paths handle failures gracefully
- [ ] Flow state is maintained correctly

### AI Assistant Integration

- [ ] Cursor understands project structure via .cursorrules
- [ ] Claude-Code can navigate project via CLAUDE.md
- [ ] Task-Master can decompose requirements effectively
- [ ] Generated code follows project patterns

### Code Quality

- [ ] All code passes ruff formatting
- [ ] All code passes pyright type checking
- [ ] Test coverage exceeds 80%
- [ ] Documentation is complete and accurate

## Success Metrics

1. Time to create first working node: <30 minutes
2. Time to create first working flow: <1 hour
3. Test coverage: >80%
4. AI-generated code acceptance rate: >90%
5. Developer satisfaction: High

## Future Enhancements

1. Web UI for flow visualization
2. Additional node templates for common patterns
3. Integration with more external services
4. Performance monitoring dashboard
5. Deployment templates for various platforms
