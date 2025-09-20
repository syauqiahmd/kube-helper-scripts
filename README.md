# Kubernetes Helper Scripts

`klog`, `kenv`, and `kdesc` are simple, interactive bash scripts designed to streamline common `kubectl` tasks.

They provide a user-friendly, numbered menu to select namespaces and resources, eliminating the need to type or copy and paste long names.

---

## Features

- **Interactive Selection**: Easily select namespaces and pods from a numbered list.
- **Colorful Interface**: Color-coded prompts and lists for better readability.
- **Keyword Filtering**: Instantly filter logs or environment variables using one or more keywords.
- **Log Following**: `klog` includes an option to stream logs in real-time (`kubectl logs -f`).
- **Zero Dependencies**: Written in pure bash with no external dependencies required.
- **Argument Support**: Pass in a namespace as an argument to skip the namespace selection menu (e.g., `./klog my-namespace`).

## Prerequisites

- `kubectl` must be installed and configured to point to a running Kubernetes cluster.

## Installation

1.  **Clone the repository or download the scripts.**

2.  **Make the scripts executable:**

    ```bash
    chmod +x klog kenv kdesc
    ```

3.  **Move the scripts to a directory in your system's PATH.**
    This is the recommended step for easy access from anywhere in your terminal.
    ```bash
    # Example: move to /usr/local/bin
    sudo mv klog kenv kdesc /usr/local/bin/
    ```

## Usage

Once installed, you can run the scripts directly from your terminal.

### klog

Run the script with `klog` or `klog <namespace>`.

```
$ klog
Please select a namespace:
1) default
2) dev
3) staging
Enter number for namespace: 2

Please select a pod from the namespace 'dev':
1) logger-dev-1-7787d59d78-j4m65
2) logger-dev-2-849d7ff58c-ghtgl
Enter number for pod: 1

Enter keywords to search (use ';' to separate): ERROR;timeout
Follow logs? (y/N): y

Searching logs for pod 'logger-dev-1-7787d59d78-j4m65' in namespace 'dev'...
[ERROR] 2025-09-21T20:00:00.000Z - A timeout occurred.
...
```

### kenv

Run the script with `kenv` or `kenv <namespace>`.

```
$ kenv dev

Please select a pod from the namespace 'dev':
1) logger-dev-1-7787d59d78-j4m65
2) logger-dev-2-849d7ff58c-ghtgl
Enter number for pod: 1

Enter keywords to filter environment variables (use ';' to separate): API

Searching environment variables for pod 'logger-dev-1-7787d59d78-j4m65' in namespace 'dev'...
API_KEY=s3cr3t-v4lu3
API_URL=https://api.example.com
```

### kdesc

Interactively describe any Kubernetes resource.

```
$ kdesc
Please select a resource type:
1) pod
2) service
3) deployment
...
Enter number for resource type: 3

Please select a namespace:
1) default
2) dev
...
Enter number for namespace: 2

Please select a resource from dev to describe:
1) my-app-deployment
...
Enter number for resource: 1

Describing deployment/my-app-deployment in namespace dev...
Name:                   my-app-deployment
Namespace:              dev
CreationTimestamp:      ...
...
```

---

## Pro-Tip: Upgrade with `fzf`

For an even better experience, you can use `fzf` (a command-line fuzzy finder) to create a powerful, interactive search menu instead of the numbered list.

**1. Install `fzf`:**

```bash
# On macOS
brew install fzf

# On other systems, see fzf repository for instructions.
```

**2. Modify the scripts:**
Replace the `for` loop and `read` command for namespace/pod selection with a single `fzf` line.

_Example for namespace selection:_

```diff
- for i in "${!ns_list[@]}"; do ... done
- read -p "..." selected_ns_index
- namespace="${ns_list[selected_ns_index-1]}"
+ namespace=$(printf "%s\n" "${ns_list[@]}" | fzf)
```

---

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
