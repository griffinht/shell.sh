import subprocess
import pytest
import os

# Constants
SCRIPT_PATH = 'shell.sh'
CODE_ENV_VAR = 'CODE'
DEFAULT_ENV_VAR = 'BRUH'
DEFAULT_VAR_VALUE = 'bruh'

@pytest.fixture(autouse=True)
def setup_env():
    """Setup and teardown environment variables for tests."""
    os.environ[CODE_ENV_VAR] = '0'
    os.environ[DEFAULT_ENV_VAR] = DEFAULT_VAR_VALUE
    yield
    del os.environ[CODE_ENV_VAR]
    if DEFAULT_ENV_VAR in os.environ:
        del os.environ[DEFAULT_ENV_VAR]

def run_script(args, check=True):
    """Helper to run the script with given arguments."""
    return subprocess.run(
        [SCRIPT_PATH] + args,
        check=check
    )

exit_code=42
# Data-driven tests
test_data = [
    # (description, arguments, expected_exit_code, setup_env)
    #("No arguments", [], 2, {}, True),
    #("Only double hyphen", ['--'], 2, {}, True),
    # Various exit codes without double hyphen
    ("Exit code", ['.', 'sh', '-c', f'exit {exit_code}'], exit_code, {}, False),
    
    # Various exit codes with double hyphen
    ("Exit code with double hyphen", ['--', 'sh', '-c', f'exit {exit_code}'], exit_code, {}, False),
    
    # Current directory as target
    #("Current directory as target", ['.'], 0, {}, True),
    #("Current directory as target with double hyphen", ['.', '--'], 0, {}, True),
    
    # Environment variable checks
    ("Custom env var check", ['default_exists', '--', 'sh', '-c', f'if [ "$BRUH" != "{DEFAULT_VAR_VALUE}" ]; then exit 1; fi'], 0, {}, False),
    
    # File existence checks
    ("Explicit env file exists", ['explicit/exists.env', '--', 'true'], 0, {}, False),
    ("Explicit env file does not exist", ['explicit/doesnotexist.env', '--', 'true'], 2, {}, True),
]

@pytest.mark.parametrize("description, arguments, expected_exit_code, env_setup, expect_failure", test_data)
def test_data_driven(description, arguments, expected_exit_code, env_setup, expect_failure):
    for key, value in env_setup.items():
        os.environ[key] = value

    if expect_failure:
        with pytest.raises(subprocess.CalledProcessError):
            run_script(arguments)
    else:
        result = run_script(arguments, check=False)
        assert result.returncode == expected_exit_code

    # Cleanup env setup
    for key in env_setup:
        del os.environ[key]

if __name__ == "__main__":
    pytest.main(["-v"])
